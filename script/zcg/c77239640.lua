--植物的愤怒 水巨藤的吸引(ZCG)
function c77239640.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --抽卡
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239640.target)
    e2:SetOperation(c77239640.activate)
    c:RegisterEffect(e2)
end
function c77239640.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c77239640.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==2 then
        Duel.ShuffleHand(p)
        Duel.BreakEffect()
        Duel.DiscardHand(p,nil,1,3,REASON_EFFECT+REASON_DISCARD)
    end
end
