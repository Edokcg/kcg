--太阳神之钢铁进化龙
function c77238318.initial_effect(c)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238318,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)	
    e1:SetCost(c77238318.cost)
    e1:SetTarget(c77238318.target)
    e1:SetOperation(c77238318.operation)
    c:RegisterEffect(e1)

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
    e52:SetOperation(c77238318.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238318.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238318.distg2)
    c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function c77238318.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238318.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77238318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttack()>1000 
	and e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(-1000)
    e:GetHandler():RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e2)	
end
function c77238318.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetHandler():GetLevel()*300)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetLevel()*300)
end
function c77238318.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end



