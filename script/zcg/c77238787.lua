--灰钢真红眼黑龙Ⅱ(ZCG)
function c77238787.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238787,0))
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c77238787.cost)	
    e1:SetTarget(c77238787.target)
    e1:SetOperation(c77238787.activate)
    c:RegisterEffect(e1)
end
function c77238787.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c77238787.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c77238787.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
