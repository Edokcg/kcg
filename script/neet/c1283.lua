--森罗的守护神 山精(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,10,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_series={SET_SYLVAN}
function s.ovfilter(c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_XYZ) and not c:IsCode(id)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,ct,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:Filter(Card.IsRace,nil,RACE_PLANT)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_EXCAVATE)==0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*200)
		c:RegisterEffect(e1)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT|REASON_EXCAVATE)
		Duel.ShuffleDeck(tp)
	else
		g:Sub(sg)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end