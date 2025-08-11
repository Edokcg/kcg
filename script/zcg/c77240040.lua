--奥西里斯之一换一
function c77240040.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --negate
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240040,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCost(c77240040.cost)
	e2:SetCondition(c77240040.condition4)
	e2:SetTarget(c77240040.target4)
	e2:SetOperation(c77240040.activate4)
	c:RegisterEffect(e2)

    --抗性
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(c77240040.efilter11)
	c:RegisterEffect(e11)
	--disable effect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetOperation(c77240040.disop12)
	c:RegisterEffect(e12)
	--disable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_DISABLE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e13:SetTarget(c77240040.distg12)
	c:RegisterEffect(e13)
	--self destroy
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_SELF_DESTROY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e14:SetTarget(c77240040.distg12)
	c:RegisterEffect(e14)
end
function c77240040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77240040.condition4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77240040.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240040.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c77240040.efilter11(e,te)
	return te:GetHandler():IsSetCard(0xa60)
end
function c77240040.disop12(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c77240040.distg12(e,c)
	return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
		and c:GetCardTarget():IsContains(e:GetHandler())
end