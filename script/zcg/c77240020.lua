--DB-天津饭-恶念初生
function c77240020.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(20049,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(c77240020.condition)
    e1:SetTarget(c77240020.target)
    e1:SetOperation(c77240020.operation)
    c:RegisterEffect(e1)
end
function c77240020.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77240020.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c77240020.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end