--奥西里斯之寄生面具
function c77240030.initial_effect(c)
    --effect
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77240030.activate)
    c:RegisterEffect(e1)
    --[[local e2=e1:Clone()
    e2:SetCode(EVENT_SPUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)]]

    --抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240030.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240030.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240030.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240030.distg12)
    c:RegisterEffect(e14)
end
function c77240030.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(2)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c77240030.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240030.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240030.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end