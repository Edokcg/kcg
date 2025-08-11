--某海贼王的心血来潮(ZCG)
function c77239683.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c77239683.operation2)
    c:RegisterEffect(e1) 
end
function c77239683.operation2(e,tp,eg,ep,ev,re,r,rp)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e3:SetTarget(c77239683.dirtg)
    Duel.RegisterEffect(e3,tp)
end
function c77239683.dirtg(e,c)
    return c:GetAttack()<=1000
end
