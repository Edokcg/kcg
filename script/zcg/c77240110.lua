--太阳神之封印龙
function c77240110.initial_effect(c)
    --coin
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(94773007,0))
    e1:SetCategory(CATEGORY_COIN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c77240110.actcon)	
    e1:SetTarget(c77240110.attg)
    e1:SetOperation(c77240110.atop)
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
    e52:SetOperation(c77240110.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77240110.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77240110.distg2)
    c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function c77240110.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240110.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77240110.actcon(e)
    return Duel.GetAttackTarget()~=nil
end
function c77240110.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c77240110.atop(e,tp,eg,ep,ev,re,r,rp)
    local coin=Duel.TossCoin(tp,1)
    if coin==1 then
        Duel.ChangeAttackTarget(nil)
    else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end

