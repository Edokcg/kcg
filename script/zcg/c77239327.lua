--殉道者 效果锁定兽(ZCG)
function c77239327.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239327.condition)
    e1:SetTarget(c77239327.target)	
    e1:SetOperation(c77239327.activate)
    c:RegisterEffect(e1)
	
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239327.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239327.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239327.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239327.disop)
    c:RegisterEffect(e13)
end
-------------------------------------------------------------------------------------------
function c77239327.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c77239327.filter(c,tpe)
    return c:IsType(tpe) and c:IsAbleToHand()
end
function c77239327.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local rtype=bit.band(re:GetActiveType(),0x7)
    if chk==0 then return Duel.IsExistingTarget(c77239327.filter,tp,0,LOCATION_GRAVE,1,nil,rtype) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c77239327.filter,tp,0,LOCATION_GRAVE,1,1,nil,rtype)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77239327.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end
-------------------------------------------------------------------------------------------
function c77239327.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239327.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239327.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end


