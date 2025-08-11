--急袭猛禽-智能猎鹰(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WINGEDBEAST),4,2,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()   
	c:SetSPSummonOnce(id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,7))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT) 
end
s.listed_series={0xba,0x95}
function s.filter(c)
	return c:IsSetCard(0xba) and c:IsAbleToHand()
end
function s.filter2(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsMonster() and c:IsAbleToGrave()
end
function s.filter3(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(id)==0
	local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(id+1)==0
	local b3=Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(id+2)==0
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE,0,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE,0,1)
	end
	if Duel.GetFlagEffect(tp,id)==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_WINGEDBEAST) end)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
		-- Lizard check
		aux.addTempLizardCheck(c,tp,function(e,c) return not c:IsOriginalRace(RACE_WINGEDBEAST) end)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end