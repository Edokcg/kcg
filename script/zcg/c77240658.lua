--神鸟凤凰(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  c:EnableReviveLimit()
--negate
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCost(s.descost)
	e11:SetCondition(s.negcon)
	e11:SetTarget(s.negtg)
	e11:SetOperation(s.negop)
	c:RegisterEffect(e11)
end
function s.cfilter(c,tp)
	if aux.IsKCGScript then
		return c:IsRace(RACE_WINGEDBEAST) and c:IsAbleToGraveAsCost()
	else 
		return c:IsRace(RACE_WINDBEAST) and c:IsAbleToGraveAsCost()
	end
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp) 
	Duel.SendtoGrave(g,REASON_COST)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	   local ct=Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,ct*2000,REASON_EFFECT)
	end
end