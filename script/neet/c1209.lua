--云魔物-烟尘（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x18),1)
--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(s.reftg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
  --cannot be target
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e20:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e20:SetCondition(s.tgcon)
	e20:SetTarget(s.tgtg)
	e20:SetValue(aux.tgoval)
	c:RegisterEffect(e20)
	local e21=e20:Clone()
	e21:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e21)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0x18}
function s.reftg(e,c)
	return c:IsSetCard(0x18)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18) and c:IsType(TYPE_MONSTER)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(s.tgfilter,1,nil)
end
function s.tgtg(e,c)
	return not (s.tgfilter(c) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetLinkedGroupCount()==0
end
function s.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end