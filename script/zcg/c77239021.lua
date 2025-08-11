--祖母暗之书
function c77239021.initial_effect(c)
	--从卡组选择3张卡加入手牌
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239021,0))	
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239021.target)
	e1:SetOperation(c77239021.activate)
	c:RegisterEffect(e1)
	
	--从墓地选择3张卡加入手牌
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239021,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c77239021.target2)
	e2:SetOperation(c77239021.activate2)
	c:RegisterEffect(e2)
end
--------------------------------------------------------------
function c77239021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239021,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,3,3,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
--------------------------------------------------------------
function c77239021.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77239021.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239021,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end