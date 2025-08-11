--六芒星的奥义 （ZCG）
function c77240235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCondition(c77240235.negcon)
	e4:SetTarget(c77240235.negtg)
	e4:SetOperation(c77240235.negop)
	c:RegisterEffect(e4)
end
function c77240235.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xa70)
end
function c77240235.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c77240235.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c77240235.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77240235.negop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.NegateActivation(ev) then
	globeDisCode=eg:GetFirst():GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c77240235.discon)
	e1:SetOperation(c77240235.disop)
	Duel.RegisterEffect(e1,tp)
end
end
function c77240235.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(globeDisCode)
end
function c77240235.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,77240235)
	Duel.ChangeChainOperation(ev,c77240235.repop)
end
function c77240235.repop(e,tp,eg,ep,ev,re,r,rp)
end
