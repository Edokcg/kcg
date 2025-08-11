--诅咒遗式术师(neet)
local s,id=GetID()
function s.initial_effect(c)
	--ritual level
	Ritual.AddWholeLevelTribute(c,aux.FilterBoolFunction(Card.IsSetCard,0x3a))  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)  
end
s.listed_series={0x3a}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.lvrescon(mustlv)
	return function(sg)
		local res,stop=aux.dncheck(sg)
		local sum=sg:GetSum(Card.GetLevel)
		return (res and sum==mustlv),(stop or sum>mustlv)
	end
end
function s.costfilter(c,tp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,c)
	return c:IsSetCard(0x3a) and c:IsRitualMonster() and c:IsLevelAbove(1) and aux.SelectUnselectGroup(g,e,tp,1,ft,s.lvrescon(c:GetLevel()),0)
end
function s.thfilter(c)
	return c:IsSetCard(0x3a) and c:IsMonster() and c:IsLevelAbove(1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.SendtoGrave(c,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,99,s.lvrescon(lv),1,tp,HINTMSG_ATOHAND,s.lvrescon(lv))
	if sg and #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	--Check for a Special Summon from the Extra Deck
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.spop)
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Cannot Special Summon from the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(c,tp)
end