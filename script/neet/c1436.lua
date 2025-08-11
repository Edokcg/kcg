--鲨鱼城塞(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),4,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()  
	--Cannot be destroyed by effects while it has Xyz materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.indcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)  
	--Halve ATK and increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER,xyzc,SUMMON_TYPE_XYZ,tp) and c:GetOverlayCount()==0
end
function s.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.filter(c)
	return c:GetBaseAttack()~=c:GetAttack()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chk) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:GetAttack()~=tc:GetBaseAttack() then
		local c=e:GetHandler()
		local val=math.abs(tc:GetAttack()-tc:GetBaseAttack())
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			--Increase ATK
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(val)
			c:RegisterEffect(e2)
		end
	end
end