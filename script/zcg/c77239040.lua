--狱魔天使
function c77239040.initial_effect(c)
	--伤害
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77239040.cost)
	e1:SetTarget(c77239040.target)
	e1:SetOperation(c77239040.operation)
	c:RegisterEffect(e1)	
end
--------------------------------------------------------------
function c77239040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,301) end
	Duel.PayLPCost(tp,300)
end
function c77239040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(900)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,900)
end
function c77239040.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
