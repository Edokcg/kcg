--暗黑的霸王(ZCG)
function c77239020.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetTarget(c77239020.destarget)
    c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function c77239020.destarget(e,c)
    return c:IsFaceup()
end
