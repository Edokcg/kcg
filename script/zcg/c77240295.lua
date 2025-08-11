--装甲 出战准备 （ZCG）
function c77240295.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77240295.activate)
	c:RegisterEffect(e1)
end
function c77240295.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e3,tp)
end