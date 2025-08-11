--魔域之壶
function c77240082.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77240082.target)
    e1:SetOperation(c77240082.activate)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------------------
function c77240082.filter(c)
    return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToDeck()
end
function c77240082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77240082.filter(chkc) end
    if chk==0 then return --[[Duel.IsPlayerCanDraw(tp,2)
        and]] Duel.IsExistingTarget(c77240082.filter,tp,LOCATION_GRAVE,0,5,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c77240082.filter,tp,LOCATION_GRAVE,0,5,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c77240082.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==5 then
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
