--魔神对决
function c77239095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c77239095.descost)
	e7:SetTarget(c77239095.target)
	e7:SetOperation(c77239095.activate)
	c:RegisterEffect(e7)
end

function c77239095.filter(c)
    return c:IsFaceup() and c:IsDestructable() and not c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c77239095.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c77239095.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239095.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c77239095.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239095.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239095.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
