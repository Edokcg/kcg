--太阳神之异能判决(ZCG)
function c77238323.initial_effect(c)
    c:EnableCounterPermit(0xa11)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c77238323.acop)
	c:RegisterEffect(e2)
    --[[add counter
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(2)	
    e1:SetCondition(c77238323.ctcon)
    e1:SetOperation(c77238323.ctop)
    c:RegisterEffect(e1)]]	
	
    --[[Negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238323,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c77238323.con)
    e3:SetCost(c77238323.cost)
    e3:SetTarget(c77238323.tar)
    e3:SetOperation(c77238323.act)
    c:RegisterEffect(e3)]]
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77238323,0))	
	e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)	
    e3:SetCode(EVENT_CHAINING)	
    e3:SetCost(c77238323.cost)
	e3:SetCondition(c77238323.condition4)
	e3:SetTarget(c77238323.target4)
	e3:SetOperation(c77238323.activate4)
	c:RegisterEffect(e3)

    --Attribute
    local e51=Effect.CreateEffect(c)
    e51:SetType(EFFECT_TYPE_SINGLE)
    e51:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e51:SetCode(EFFECT_ADD_ATTRIBUTE)
    e51:SetRange(LOCATION_MZONE)
    e51:SetValue(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
    c:RegisterEffect(e51)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77238323.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238323.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238323.distg2)
    c:RegisterEffect(e54)	
end
-------------------------------------------------------------------------
function c77238323.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238323.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------------------
function c77238323.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0xa11,1)
	end
end
--[[function c77238323.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c77238323.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x28d,1)
end]]
-------------------------------------------------------------------------------------
function c77238323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,1,REASON_COST)
end
--[[function c77238323.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) --and ep~=tp
end]]
--[[function c77238323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end]]
function c77238323.condition4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77238323.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77238323.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

