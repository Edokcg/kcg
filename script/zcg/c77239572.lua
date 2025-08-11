--恶魂的伪物(ZCG)
function c77239572.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
	
    --cannot trigger
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_TRIGGER)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(0,0xa)
    e1:SetTarget(c77239572.distg)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,LOCATION_GRAVE)
    c:RegisterEffect(e2)
end
function c77239572.distg(e,c)
    return c:IsType(TYPE_TRAP)
end

