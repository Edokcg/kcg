--女子佣兵 光灵
function c77239505.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239505,1))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(c77239505.spcon)
    e1:SetOperation(c77239505.spop)
    c:RegisterEffect(e1)

    --decrease tribute
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DECREASE_TRIBUTE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_HAND,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa80))
    e4:SetValue(0x3)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
    c:RegisterEffect(e5)
end
function c77239505.ccfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0xa80) and c:IsType(TYPE_MONSTER) and not c:IsCode(77239505)
end
function c77239505.spcon(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then return false end
    local c=e:GetHandler()
    return eg:IsExists(c77239505.ccfilter,1,nil,tp)
end
function c77239505.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
