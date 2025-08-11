--伯爵的审判(ZCG)
function c77239541.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(c77239541.condition)
    e1:SetTarget(c77239541.target)
    e1:SetOperation(c77239541.operation)
    c:RegisterEffect(e1)
end
function c77239541.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c77239541.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(ev*2)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev*2)
end
function c77239541.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
