--稻草人的诅咒(ZCG)
function c77239585.initial_effect(c)
	c:EnableCounterPermit(0xa11)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c77239585.rcon)
	e2:SetOperation(c77239585.op)
	c:RegisterEffect(e2)
	--counter1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239585,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c77239585.descost)
	e3:SetTarget(c77239585.target)
	e3:SetOperation(c77239585.operation)
	c:RegisterEffect(e3)
	--counter2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239585,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c77239585.descost1)
	e4:SetTarget(c77239585.target1)
	e4:SetOperation(c77239585.operation1)
	c:RegisterEffect(e4)
	--counter3
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239585,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c77239585.descost2)
	e5:SetTarget(c77239585.target2)
	e5:SetOperation(c77239585.operation2)
	c:RegisterEffect(e5)
	--counter4
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239585,3))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(c77239585.descost3)
	e6:SetOperation(c77239585.operation3)
	c:RegisterEffect(e6)
end
function c77239585.rcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c77239585.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:GetCount()
	if c~=e:GetHandler() then
		e:GetHandler():AddCounter(0xa11,ct)
	end
end
function c77239585.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,1,REASON_COST)
end
function c77239585.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239585.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239585.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77239585.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239585.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239585.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c77239585.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,2,REASON_COST)
end
function c77239585.filter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c77239585.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239585.filter1,tp,0,LOCATION_ONFIELD,1,c) end
	local sg1=Duel.GetMatchingGroup(c77239585.filter1,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg1,sg1:GetCount(),0,0)
end
function c77239585.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(c77239585.filter1,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg1,REASON_EFFECT)
end
function c77239585.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,3,REASON_COST)
end
function c77239585.filter2(c)
	return c:IsDestructable()
end
function c77239585.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239585.filter2,tp,0,LOCATION_ONFIELD,1,c) end
	local sg2=Duel.GetMatchingGroup(c77239585.filter2,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg2,sg2:GetCount(),0,0)
end
function c77239585.operation2(e,tp,eg,ep,ev,re,r,rp)
	local sg2=Duel.GetMatchingGroup(c77239585.filter2,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg2,REASON_EFFECT)
end
function c77239585.descost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,4,REASON_COST)
end
function c77239585.filter3(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c77239585.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0) 
	local gc=Duel.GetMatchingGroup(c77239585.filter3,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
	Duel.Remove(gc,POS_FACEUP,REASON_EFFECT)
end
