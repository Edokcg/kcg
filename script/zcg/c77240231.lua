--殉道者 祭师摩克达（ZCG）
function c77240231.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240231,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c77240231.condition)
	e1:SetOperation(c77240231.operation)
	c:RegisterEffect(e1)
 local e4=Effect.CreateEffect(c)
	   e4:SetDescription(aux.Stringid(77240231,1))
	   e4:SetType(EFFECT_TYPE_IGNITION)
	   e4:SetRange(LOCATION_MZONE)
	   e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	   e4:SetTarget(c77240231.sptg)
	   e4:SetOperation(c77240231.spop)
	   c:RegisterEffect(e4)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240231.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240231.distg9)
	c:RegisterEffect(e12)
end
function c77240231.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240231.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240231.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0xa60)
end
function c77240231.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c77240231.spfilter(c,e,tp)
	return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240231.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c77240231.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
   if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
 and Duel.IsExistingMatchingCard(c77240231.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:IsAttackAbove(1000) end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77240231.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsFaceup() or c:GetAttack()<1000 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240231.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end