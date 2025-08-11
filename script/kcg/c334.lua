--天地葬造 (K)
function c334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(910904,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	  e2:SetCost(c334.cost)
	e2:SetCondition(c334.thcon)
	e2:SetTarget(c334.thtg)
	e2:SetOperation(c334.thop)
	c:RegisterEffect(e2)
end

function c334.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c334.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c334.filter(c)
	return c:IsAbleToHand()
end
function c334.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c334.filter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c334.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c334.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			local sg1=sg:GetFirst()
			if sg1:IsAbleToHand() then 
			if Duel.SendtoHand(sg1,nil,REASON_EFFECT)~=0  then
			Duel.ConfirmCards(1-tp,sg)
			Duel.Destroy(sg1,REASON_EFFECT) end
			else Duel.SendtoGrave(sg1,REASON_EFFECT) end
		Duel.ShuffleDeck(tp)
	end
end
