--小偷盗贼(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	g=g:Filter(Card.IsAbleToHand,nil)
	if g:GetCount()>0 then
	   Duel.ConfirmCards(tp,g)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   g=g:Select(tp,1,1,nil)
	   if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ShuffleHand(1-tp)
end
