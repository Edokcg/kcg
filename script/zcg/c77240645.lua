--BT黑羽 眺望翠鸟(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	Duel.RegisterEffect(e2,tp)
end