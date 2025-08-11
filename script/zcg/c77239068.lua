--5除2(ZCG)
function c77239068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239068.target)
	e1:SetOperation(c77239068.activate)
	c:RegisterEffect(e1)
end
function c77239068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c77239068.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(77239068,0))
	local sg=g:Select(1-tp,3,3,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    Duel.ShuffleHand(tp)	
end
