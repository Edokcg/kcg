--Reaper Scythe - Dreadsctyeh
function c170000206.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c170000206.target)
	e1:SetOperation(c170000206.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c170000206.eqlimit)
	c:RegisterEffect(e2)
	--equip effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c170000206.val)
	c:RegisterEffect(e3)
	--Tribute all other monster
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c170000206.operation2)
	c:RegisterEffect(e4)
end
function c170000206.eqlimit(e,c)
	return c:IsCode(18175965)
end
function c170000206.filter(c)
	return c:IsFaceup() and c:IsCode(18175965)
end
function c170000206.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c170000206.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c170000206.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c170000206.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c170000206.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c170000206.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*500
end
function c170000206.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingTarget(Card.IsReleaseable,tp,LOCATION_MZONE,0,1,e:GetHandler():GetEquipTarget()) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
local rg=Duel.GetMatchingGroup(Card.IsReleaseable,tp,LOCATION_MZONE,0,e:GetHandler():GetEquipTarget())
Duel.Release(rg,REASON_COST)
end