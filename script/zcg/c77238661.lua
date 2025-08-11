--三国传-张飞
function c77238661.initial_effect(c)
    --immune spell
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77238661.efilter)
    c:RegisterEffect(e1)

    --attack all
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_ATTACK_ALL)
    e3:SetValue(1)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------
function c77238661.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end


