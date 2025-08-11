--殉道者 改装兔
function c77239346.initial_effect(c)
    --attack up
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetDescription(aux.Stringid(77239346,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239346.condition)	
    e1:SetOperation(c77239346.operation)
    c:RegisterEffect(e1)

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239346.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239346.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239346.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239346.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239346.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLevel()>1
end
function c77239346.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetBaseAttack()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_LEVEL)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(-1)
        c:RegisterEffect(e2)
    end
end
------------------------------------------------------------------------------------
function c77239346.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239346.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239346.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

