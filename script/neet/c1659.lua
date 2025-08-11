--巨石遗物精灵（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
--Ritual Summon
	local e2=Ritual.CreateProc(c,RITPROC_GREATER,aux.FilterBoolFunction(Card.IsSetCard,0x138),nil,aux.Stringid(id,1),nil,nil,nil,nil,LOCATION_HAND+LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.ritcon)
	c:RegisterEffect(e2)

end
s.listed_series={0x138}
function s.ritcon()
	return Duel.IsMainPhase()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end