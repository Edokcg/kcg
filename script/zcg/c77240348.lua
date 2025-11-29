--拷贝猫(ZCG)
local s,id=GetID()
function s.initial_effect(c)
			--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	local code=tc:GetOriginalCode()
		e:GetHandler():SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		e:GetHandler():CancelToGrave()
		Duel.SendtoHand(e:GetHandler(),tp,REASON_RULE)
end 