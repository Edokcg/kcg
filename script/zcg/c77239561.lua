--女仆的援手(ZCG)
function c77239561.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239561.condition)
    e1:SetTarget(c77239561.target)
    e1:SetOperation(c77239561.operation)
    c:RegisterEffect(e1)
end
function c77239561.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=1000
end
function c77239561.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c77239561.operation(e,tp,eg,ep,ev,re,r,rp)
    local rt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*1000
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rt,REASON_EFFECT)
end
