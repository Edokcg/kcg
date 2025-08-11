--装甲 令人疯狂的武器 （ZCG）
function c77240282.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c77240282.target)
	e1:SetOperation(c77240282.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c77240282.atkval)
	c:RegisterEffect(e3)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c77240282.efilter)
	c:RegisterEffect(e0)
end
function c77240282.efilter(e,re)
	local tc=e:GetHandler():GetEquipTarget()
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c77240282.atkval(e,c)
 local tc=e:GetHandler():GetEquipTarget()
	 if tc:IsCode(77240280) then return 3000
else
return 1000
end
end
function c77240282.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77240282.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end