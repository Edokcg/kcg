--魔导之瞳
function c77239089.initial_effect(c)
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c77239089.discon)
    e1:SetTarget(c77239089.distg)
    e1:SetOperation(c77239089.disop)
    c:RegisterEffect(e1)
end
function c77239089.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev) and ep~=tp
end
function c77239089.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    end
end
function c77239089.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    Duel.NegateActivation(ev)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
