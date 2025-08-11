--植物的愤怒 青苔石人
function c77239625.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(3)
    e1:SetValue(c77239625.valcon)
    c:RegisterEffect(e1)
	
    --battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)	
end
function c77239625.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
