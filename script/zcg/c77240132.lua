--天龙之结界圣物
function c77240132.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(1,1)
    e2:SetTarget(c77240132.splimit)
    c:RegisterEffect(e2)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77240132.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77240132.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77240132.distg2)
    c:RegisterEffect(e54)
end
function c77240132.splimit(e,c)
    return not (c:IsSetCard(0xdb97) or c:IsSetCard(0xdb98))
end

function c77240132.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240132.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end