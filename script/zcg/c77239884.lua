--记忆的容器
function c77239884.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239884.target)
    e1:SetOperation(c77239884.activate)
    c:RegisterEffect(e1)
end
function c77239884.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c77239884.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local g=Duel.GetFieldGroup(p,LOCATION_GRAVE,0)
    if g:GetCount()==0 then return end
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
