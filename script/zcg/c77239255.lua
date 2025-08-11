--奥利哈刚 超强欲之壶(ZCG)
function c77239255.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    c:RegisterEffect(e1)
	
    --回复
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DRAW)
    e2:SetCondition(c77239255.handcon)
    e2:SetOperation(c77239255.recop)
    c:RegisterEffect(e2)
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239255,0))	
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)	
    e3:SetTarget(c77239255.target1)
    e3:SetOperation(c77239255.activate1)
	c:RegisterEffect(e3)
	
    --抽卡
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239255,1))	
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)	
    e4:SetTarget(c77239255.target)
    e4:SetOperation(c77239255.activate)
    c:RegisterEffect(e4)
	
    --抽卡
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239255,2))	
    e5:SetCategory(CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c77239255.target2)
    e5:SetOperation(c77239255.activate2)
    c:RegisterEffect(e5)
	
end
---------------------------------------------------------------------------------
function c77239255.filter(c)
    return c:IsType(TYPE_SPELL)
end
function c77239255.handcon(e)
    local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
    return not g:IsExists(c77239255.filter,1,nil)
end
function c77239255.recop(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then return end
    Duel.Recover(tp,1000,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239255.filter1(c)
    return c:IsAbleToHand()
end
function c77239255.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239255.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239255.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239255.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
	if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
---------------------------------------------------------------------------------
function c77239255.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(5)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c77239255.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239255.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
    Duel.SetTargetPlayer(tp)	
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239255.activate2(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,63,nil)
    if g:GetCount()==0 then return end
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(p)
end