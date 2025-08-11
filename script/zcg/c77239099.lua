--神石板 王之战甲(ZCG)
function c77239099.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239099.target)
    e1:SetOperation(c77239099.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c77239099.eqlimit)
    c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239099.efilter)	
    c:RegisterEffect(e4)	
end
-------------------------------------------------------------------
function c77239099.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa20)
end
function c77239099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239099.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239099.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239099.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239099.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239099.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler() and c:IsSetCard(0xa20)
end
-------------------------------------------------------------------
function c77239099.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end