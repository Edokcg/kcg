--奥西里斯之邪恶贝斯
function c77239728.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239728,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c77239728.condition)
    e1:SetTarget(c77239728.target)
    e1:SetOperation(c77239728.operation)
    c:RegisterEffect(e1)
	
    --抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77239728.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77239728.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77239728.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77239728.distg12)
    c:RegisterEffect(e14)
end
---------------------------------------------------------------------------------
function c77239728.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77239728.filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function c77239728.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239728.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    local dam=Duel.GetMatchingGroupCount(c77239728.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)*1000
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239728.operation(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetMatchingGroupCount(c77239728.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)*1000
    Duel.Damage(p,dam,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239728.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77239728.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239728.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end
