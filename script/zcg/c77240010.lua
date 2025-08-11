--CNo.10 白辉士 启明者 闪光
function c77240010.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,4)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240010,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77240010.cost)
	e1:SetTarget(c77240010.target)
	e1:SetOperation(c77240010.operation)
	c:RegisterEffect(e1)
	
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240010,1))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c77240010.con)
	e1:SetTarget(c77240010.tg)
	e1:SetOperation(c77240010.op)
	c:RegisterEffect(e1)	
end
--------------------------------------------------------------------
function c77240010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77240010.filter(c)
	return c:IsAbleToGrave()
end
function c77240010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c77240010.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c77240010.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c77240010.filter,p,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(p,2,REASON_EFFECT)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)		
	end
end
--------------------------------------------------------------------
function c77240010.filter2(c)
	return c:IsCode(11411223)
end
function c77240010.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c77240010.filter2,1,nil)
end
function c77240010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c77240010.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
