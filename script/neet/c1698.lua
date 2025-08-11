--奴隶象（neet）
local s,id=GetID()
function s.initial_effect(c)
	--summon/special summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--name + condition * 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(s.spcon2)
	e4:SetOperation(s.spop2)
	e4:SetValue(SUMMON_TYPE_SPECIAL)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--name + condition * 1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(s.spcon3)
	e6:SetOperation(s.spop3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e7:SetTargetRange(LOCATION_EXTRA,0)
	e7:SetTarget(s.eftg2)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end
s.listed_series={0x19}
function s.filter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,130,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,130,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0x19)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(s.cfilter,nil,tp)>0 then
	  Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function s.eftg(e,c)
	return c:IsCode(33652635,27346636,3779662)
end
function s.namefilter(c)
	return c:IsCode(id) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.confilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x19) and (c:IsAbleToExtra() or c:IsAbleToDeck())
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,2,nil)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.namefilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)	
	local g2=Duel.SelectMatchingCard(tp,s.confilter,tp,LOCATION_MZONE,0,2,2,nil)
	--Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function s.eftg2(e,c)
	return c:IsCode(90957527,48156348)
end
function s.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.namefilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)	
	local g2=Duel.SelectMatchingCard(tp,s.confilter,tp,LOCATION_MZONE,0,1,1,nil)
	--Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end