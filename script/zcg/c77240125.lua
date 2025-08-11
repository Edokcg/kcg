--天龙 圣剑龙
function c77240125.initial_effect(c)
    --dis field
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(c77240125.operation)
    c:RegisterEffect(e1)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77240125.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77240125.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77240125.distg2)
    c:RegisterEffect(e54)
end
function c77240125.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
    --disable field
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetOperation(c77240125.disop)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e:GetHandler():RegisterEffect(e1)
end
function c77240125.disop(e,tp)
    local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0)
    return dis1
end

function c77240125.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240125.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end