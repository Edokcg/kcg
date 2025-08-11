--混沌神官
function c77239053.initial_effect(c)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)   
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239053.discon)
    e1:SetTarget(c77239053.distg)
    e1:SetOperation(c77239053.disop)
    c:RegisterEffect(e1)
	
	--减少祭品
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c77239053.rfilter)
	e2:SetValue(0x1)
	c:RegisterEffect(e2)	
end

function c77239053.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c77239053.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239053.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end

function c77239053.rfilter(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end