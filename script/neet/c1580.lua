--强化支援机械·重装加速器(neet)
local s,id=GetID()
function s.initial_effect(c)
	local f,oldequip,oldprotect=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),false
	if oldprotect == nil then oldprotect = oldequip end
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(Auxiliary.UnionTarget(f,oldequip))
	e1:SetOperation(Auxiliary.UnionOperation2(f))
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	if oldequip then
		e2:SetCondition(Auxiliary.IsUnionState)
	else
		e2:SetCondition(function(e) return e:GetHandler():GetEquipTarget()end)
	end
	e2:SetTarget(Auxiliary.UnionSumTarget(oldequip))
	e2:SetOperation(Auxiliary.UnionSumOperation(oldequip))
	c:RegisterEffect(e2)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	if oldprotect then
		e3:SetCondition(Auxiliary.IsUnionState)
	else
		e3:SetCondition(function(e) return e:GetHandler():GetEquipTarget()end)
	end
	e3:SetValue(Auxiliary.UnionReplace(oldprotect))
	c:RegisterEffect(e3)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(Auxiliary.UnionLimit(f))
	c:RegisterEffect(e4)
	--auxiliary function compatibility
	if oldequip then
		local m=c:GetMetatable()
		m.old_union=true
	end
	--Halve eqc ATK, and if you do, it can direct attackly
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1) 
	if oldprotect then
		e5:SetCondition(Auxiliary.IsUnionState)
	else
		e5:SetCondition(function(e) return e:GetHandler():GetEquipTarget()end)
	end
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(s.datop)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1068)
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTarget(s.eqtg)
	e6:SetOperation(s.eqop)
	c:RegisterEffect(e6)
end
function Auxiliary.UnionOperation2(f)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or (c:IsFacedown() and  not c:IsLocation(LOCATION_HAND)) then return end
		if not tc:IsRelateToEffect(e) or (f and not f(tc)) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		if not Duel.Equip(tp,c,tc,true) then return end
		aux.SetUnionState(c)
	end
end
function s.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and ec:IsFaceup() then
		--Halve its original ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(ec:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
		--Can attack directly
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(3205)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e2)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(4)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,0,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-3)
	tc:RegisterEffect(e1)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown()
		or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	aux.SetUnionState(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end