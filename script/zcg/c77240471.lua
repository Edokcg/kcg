--奥利哈刚 超强欲之壶(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.thtg2)
	e1:SetOperation(s.thop2)
	c:RegisterEffect(e1)
--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98710501)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
   --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,98710502)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.thtg3)
	e3:SetOperation(s.thop3)
	c:RegisterEffect(e3)
end
function s.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.filter2(c)
	return c:IsAbleToDeck()
end
function s.thop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local t=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SendtoDeck(t,nil,2,REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.Draw(p,d,REASON_EFFECT)
		Duel.Recover(tp,ct*1000,REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.filter(c)
	return c:IsAbleToHand()
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local t1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if not t1 then return end
	local t2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if not t2 then return end
	local t3=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if not t3 then return end
	local g=Group.FromCards(t1,t2,t3)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end