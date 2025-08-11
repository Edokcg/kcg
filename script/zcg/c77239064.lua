--反射板
function c77239064.initial_effect(c)
    --change battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239064.atktg)
    e1:SetOperation(c77239064.atkop)
    c:RegisterEffect(e1)

    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239064.desreptg)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------
function c77239064.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239064.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local at=Duel.GetAttacker()
        if --[[at:IsAttackable() and]] not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
           Duel.CalculateDamage(at,tc)
        end
    end
end
---------------------------------------------------------------------
function c77239064.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsReason(REASON_RULE) end
    if not e:GetHandler():IsReason(REASON_RULE) then
        Duel.Damage(1-tp,500,REASON_EFFECT)
        return true
    else return false end
end
