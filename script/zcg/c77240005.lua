--冥界の復讐
function c77240005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77240005.cost)
	e1:SetTarget(c77240005.target)
	e1:SetOperation(c77240005.operation)
	c:RegisterEffect(e1)
end
function c77240005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp-1)
end
function c77240005.filter(c)
	return c:IsAbleToRemove()
end
function c77240005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240005.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,c) end
	local sg=Duel.GetMatchingGroup(c77240005.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240005.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240005.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
