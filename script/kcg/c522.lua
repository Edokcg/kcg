--ＦＮｏ．０ 未来皇ホープ・ゼアル
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon procedure: 2 Xyz Monsters with the same Rank
	Xyz.AddProcedureX(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_XYZ),nil,2,nil,nil,Xyz.InfiniteMats,nil,false,s.xyzcheck)

	--This card cannot be destroyed by battle or card effects this turn
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(3008)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e01:SetValue(1)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e02)

	--Gains ATK/DEF equal to the total Ranks of all Xyz Monsters you control and in your opponent's GY x 500
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c) return (Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_XYZ),e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_GRAVE,nil):GetSum(Card.GetRank)+Duel.GetOverlayGroup(e:GetHandlerPlayer(),1,0):Filter(Card.IsType,nil,TYPE_XYZ):GetSum(Card.GetRank))*500 end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	
	--特殊召唤不会被无效化
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.con)
		ge1:SetOperation(s.op)
		Duel.RegisterEffect(ge1,0)
	end)

	--Your opponent's monsters cannot target monsters for attacks, except this one
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(function(e,c) return c~=e:GetHandler() end)
	c:RegisterEffect(e3)
	--Your opponent cannot target target other cards on the field with card effects
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)

	--Take control of 1 monster your opponent controls
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.ctcon)
	e5:SetCost(Cost.DetachFromSelf(1))
	e5:SetTarget(s.cttg)
	e5:SetOperation(s.ctop)
	c:RegisterEffect(e5)
end
s.xyz_number=0

function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(EFFECT_EQUIP_SPELL_XYZ_MAT) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		return Duel.IsPlayerAffectedByEffect(i,EFFECT_CANNOT_SPECIAL_SUMMON)
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return (not target or target(e,c,tp,sumtp,sumpos)) and c~=zexal
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		local effs={Duel.GetPlayerEffect(i,EFFECT_CANNOT_SPECIAL_SUMMON)}
		for _,eff in ipairs(effs) do
			if eff:GetLabel()~=364 then
				target=eff:GetTarget()
				eff:SetTarget(s.splimit)
				eff:SetLabel(364)
			end
		end
	end
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local trig_loc,trig_p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
	return trig_p==1-tp and (trig_loc&LOCATION_ONFIELD)>0 and Duel.IsChainNegatable(ev)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,0)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT))
end
function s.filter2(c)
	return c:IsFacedown() 
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsLocation(LOCATION_SZONE) and rc:IsFacedown()
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g,tp)
	end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	local tc2=g2:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	while tc2 do
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_FIELD)
		  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		  e3:SetRange(LOCATION_MZONE)
		  e3:SetTargetRange(0,1)
		  e3:SetValue(s.aclimit)
		  e3:SetReset(RESET_PHASE+PHASE_END)
		  c:RegisterEffect(e3)
		  tc2=g2:GetNext()
	end
end
