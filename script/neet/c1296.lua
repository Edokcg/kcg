--魔偶甜点贵族·软糖千金(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x71),1,1)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.matcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
end
s.listed_series={0x71}
function s.matcheck(e,c)
	local tc=c:GetMaterial():GetFirst()
	if tc:IsSetCard(0x71) and tc:IsLevel(3) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	elseif tc:IsSetCard(0x71) and tc:IsLevel(4) then
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	elseif tc:IsSetCard(0x71) and tc:IsLevel(5) then
		c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
end
function s.mfilter(c)
	return c:IsSetCard(0x71) and c:IsMonster() and c:IsAbleToHand()
end
function s.stfilter(c)
	return c:IsSetCard(0x71) and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.tdfilter(c)
	return c:IsSetCard(0x71) and c:IsMonster() and c:IsAbleToDeck()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(id)~=0
	local b2=Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(id+1)~=0
	local b3=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(id+2)~=0
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==3 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_GRAVE)

	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			g1:Merge(g2)
			if #g1>0 then
				Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end