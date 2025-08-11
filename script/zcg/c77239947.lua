--沉默的王lvmax
function c77239947.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77239947.spcon)
	e2:SetOperation(c77239947.spop)
	c:RegisterEffect(e2)
	
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)	
	
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_ONFIELD)
	c:RegisterEffect(e4)
	
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(aux.chainreg)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c77239947.damop)
	c:RegisterEffect(e6)	
	
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c77239947.con)
	e7:SetTarget(c77239947.sptg1)
	e7:SetOperation(c77239947.spop1)
	c:RegisterEffect(e7)	
end
-------------------------------------------------------------------------
function c77239947.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLP(tp)~=8
end
function c77239947.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.SetLP(tp,8)
end
-------------------------------------------------------------------------
function c77239947.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if e:GetHandler():GetFlagEffect(1)>0 and rp==tp then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end
-------------------------------------------------------------------------
function c77239947.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239947.sfilter1(c,e,tp)
	return c:IsCode(77239943) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239947.sfilter2(c,e,tp)
	return c:IsCode(77239944) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239947.sfilter3(c,e,tp)
	return c:IsCode(77239945) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239947.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239947.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239947.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239947.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239947.spop1(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77239947.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c77239947.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c77239947.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEUP)
	end
end