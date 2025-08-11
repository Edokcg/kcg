--在
function c77239077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c77239077.condition)
	e1:SetTarget(c77239077.target)
	e1:SetOperation(c77239077.activate)
	c:RegisterEffect(e1)
end
function c77239077.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and re:GetHandler():IsLevelAbove(5)
end
--[[function c77239077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239077.activate(e,tp,eg,ep,ev,re,r,rp)
	local atk=eg:GetAttack()
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,atk,REASON_EFFECT)		
    end		
end]]

function c77239077.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        local g=Duel.SetTargetCard(re:GetHandler())	
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239077.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local dam=tc:GetAttack()
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
        Duel.Destroy(eg,REASON_EFFECT)
        Duel.Damage(1-tp,dam,REASON_EFFECT) 		
    end
end