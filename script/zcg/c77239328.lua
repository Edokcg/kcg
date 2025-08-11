--殉道者 火焰驱魔人(ZCG)
function c77239328.initial_effect(c)
    --Destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239328.destg)
    e1:SetOperation(c77239328.desop)
    c:RegisterEffect(e1)
	

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239328.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239328.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239328.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239328.disop)
    c:RegisterEffect(e13)
end
--------------------------------------------------------------------------
function c77239328.desfilter(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c77239328.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239328.desfilter(chkc,c:GetAttack()) end
    if chk==0 then return Duel.IsExistingTarget(c77239328.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239328.desfilter,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239328.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT) then      
        Duel.Damage(1-tp,2000,REASON_EFFECT)		
    end
end
--------------------------------------------------------------------------
function c77239328.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239328.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239328.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end