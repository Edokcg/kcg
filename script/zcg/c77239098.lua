--神石板 王之气息(ZCG)
function c77239098.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239098.target)
    e1:SetOperation(c77239098.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c77239098.eqlimit)
    c:RegisterEffect(e3)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------------
function c77239098.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa20)
end
function c77239098.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239098.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239098.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239098.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239098.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239098.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler() and c:IsSetCard(0xa20)
end

