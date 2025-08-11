--殉道者之盾
function c77239362.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77239362.target)
    e1:SetOperation(c77239362.operation)
    c:RegisterEffect(e1)
    --equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetValue(c77239362.eqlimit)
    c:RegisterEffect(e2)

    --indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetCountLimit(2)
    e3:SetValue(c77239362.valcon)
    c:RegisterEffect(e3)

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239362.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239362.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239362.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239362.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------
function c77239362.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa60)
end
function c77239362.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239362.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239362.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239362.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239362.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239362.eqlimit(e,c)
    return c:IsSetCard(0xa60)
end
function c77239362.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239362.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239362.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239362.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

