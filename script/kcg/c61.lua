--CNo.39 希望皇ホープレイ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,3,s.ovfilter,aux.Stringid(56840427,1))

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--attack up
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(56840427,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp) return Duel.GetLP(tp)<=1000 end)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_EQUIP)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	-- --self destroy
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetCode(EFFECT_DISABLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCondition(s.descon)
	-- c:RegisterEffect(e2)
	-- local e3=e2:Clone()
	-- e3:SetCode(EFFECT_DISABLE_EFFECT)
	-- c:RegisterEffect(e3)
end
s.xyz_number=39
s.listed_series = {0x48}
s.listed_names={84013237,60992364,2896663,68679595,75402014,1562,40941889}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter2,c:GetControler(),0,LOCATION_MZONE,1,c)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(84013237)
end
 function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-1000)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			g:GetFirst():RegisterEffect(e2)
		end
	end
end

function s.filter(c,ec)
	return c:GetEquipTarget()==ec
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,e:GetHandler()) and (eg:IsExists(Card.IsCode,1,nil,60992364) or eg:IsExists(Card.IsCode,1,nil,2896663)or eg:IsExists(Card.IsCode,1,nil,40941889)) end
	local dg=eg:Filter(s.filter,nil,e:GetHandler())
	e:SetLabelObject(dg)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local c=e:GetHandler()
	local code1=0
	local code2=0
	local code3=0
	local code0=0
	for tc in aux.Next(tg) do
		if tc:IsCode(60992364) then code1=68679595 code0=60992364 end
		if tc:IsCode(2896663) then code2=75402014 code0=2896663 end
		if tc:IsCode(40941889) then code3=1562 code0=40941889 end
	end
	if (code1>0 and code2>0) or (code1>0 and code3>0) or (code1>0 and code3>0) then
		local opt=Duel.SelectEffect(tp,
			{code1>0,aux.Stringid(id,2)},
			{code2>0,aux.Stringid(id,3)},
			{code3>0,aux.Stringid(id,4)})
		if opt==1 then
			code2,code3=0,0 code0=60992364
		elseif opt==2 then
			code1,code3=0,0 code0=2896663
		elseif opt==3 then
			code1,code2=0,0 code0=40941889
		end
	end
	if code1==0 and code2==0 and code3==0 then return end
	-- local e8 = Effect.CreateEffect(c)
	-- e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e8:SetCode(EVENT_LEAVE_FIELD_P)
	-- e8:SetRange(LOCATION_MZONE)
	-- e8:SetOperation(s.recover)
	-- e8:SetReset(RESET_EVENT + 0x1fe0000)
	-- e8:SetLabel(code0)
	-- c:RegisterEffect(e8, true)
	-- local e9 = Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_LEAVE_FIELD_P)
	-- e9:SetOperation(s.recover2)
	-- e9:SetReset(RESET_EVENT+0x1fe0000)
	-- c:RegisterEffect(e9, true)
	c:SetEntityCode(math.max(code1,code2,code3),nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,EFFECT_FLAG_CANNOT_DISABLE,RESET_EVENT+RESETS_STANDARD,c,true)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-- function s.filter2(c,ec,code)
-- 	return c:GetEquipTarget()==ec and c:IsCode(code)
-- end
-- function s.recover(e,tp,eg,ep,ev,re,r,rp)
-- 	local code=e:GetLabel()
-- 	local c=e:GetHandler()
-- 	local eqg=c:GetEquipGroup()
-- 	eqg:Sub(eg)
-- 	if eg:IsExists(s.filter2,1,nil,c,code) and not eqg:IsExists(Card.IsCode,1,c,code) and not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 	end
-- end
-- function s.recover2(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	if not c:IsOriginalCode(id) then
-- 		c:SetEntityCode(id,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
-- 	end
-- end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(e:GetHandlerPlayer())>=1000
end