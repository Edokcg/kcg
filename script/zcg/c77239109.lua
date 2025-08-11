--神石板 游戏(Z)
function c77239109.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239109.target)
    e1:SetOperation(c77239109.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e5=Effect.CreateEffect(c)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EQUIP_LIMIT)
    e5:SetValue(1)
    c:RegisterEffect(e5)	
	
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c77239109.efilter)
	c:RegisterEffect(e2)

	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c77239109.actcon)	
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
---------------------------------------------------
function c77239109.filter(c)
    return c:IsFaceup()
end
function c77239109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239109.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239109.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239109.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239109.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
---------------------------------------------------
function c77239109.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
---------------------------------------------------
function c77239109.actcon(e)
    return e:GetHandler():GetEquipTarget():GetCode()==77239107
end