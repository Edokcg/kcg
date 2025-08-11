--奥利哈刚的诅咒(ZCG)
function c77239279.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c77239279.con)
	e1:SetTarget(c77239279.tg)
	e1:SetOperation(c77239279.op)
	c:RegisterEffect(e1)
end
function c77239279.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end
function c77239279.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
end
function c77239279.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_SZONE,0,nil,77239279)==3 then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	if Duel.GetTurnPlayer()==tp then
		local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)
		if rg:GetCount()>0 then
			Duel.ConfirmCards(tp,rg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=rg:Select(tp,5,5,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	else
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
		if rg:GetCount()>0 then
			Duel.ConfirmCards(tp,rg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=rg:Select(tp,10,10,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
end