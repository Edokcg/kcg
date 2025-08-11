--不平等条约(ZCG)
function c77239172.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(c77239172.condition)
    c:RegisterEffect(e1)

    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DRAW)
    e2:SetOperation(c77239172.recop)
    c:RegisterEffect(e2)
end
function c77239172.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetFirst():IsControler(tp) and Duel.GetAttackTarget()==nil
end
function c77239172.recop(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    Duel.Damage(1-tp,100,REASON_EFFECT)
    Duel.Recover(tp,100,REASON_EFFECT)
end