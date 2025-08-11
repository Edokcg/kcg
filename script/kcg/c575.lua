--黑暗磁場 (KA)
function c575.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c575.target)
	e1:SetOperation(c575.operation)
	c:RegisterEffect(e1)  
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c575.eqlimit)
	c:RegisterEffect(e2) 
	--cannot act spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c575.con)
	e3:SetValue(c575.aclimit)
	c:RegisterEffect(e3) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c575.con)
	e2:SetTarget(c575.distg)
	c:RegisterEffect(e2)
end

function c575.distg(e,c)
	return c:IsType(TYPE_SPELL)
end

function c575.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end

function c575.eqlimit(e,c)
	return c:IsSetCard(0x900)
end

function c575.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end

function c575.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c575.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c575.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c575.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c575.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c575.con(e)
	return e:GetHandler():GetEquipTarget()~=nil
end

