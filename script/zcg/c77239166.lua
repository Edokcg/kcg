--时间的消停(ZCG)
function c77239166.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c77239166.condition)
    e1:SetOperation(c77239166.activate)
    c:RegisterEffect(e1)
end
function c77239166.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return tp~=Duel.GetTurnPlayer() and bit.band(ph,PHASE_MAIN2+PHASE_END)==0
end
function c77239166.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
    e1:SetTargetRange(0,1)
    Duel.RegisterEffect(e1,tp)
end