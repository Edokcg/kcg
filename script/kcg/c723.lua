--FNo.0 未来皇ホープ－フューチャー・スラッシュ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
   Xyz.AddProcedureX(c,s.mfilter,nil,2,s.ovfilter,aux.Stringid(43490025,1),nil,nil,false,s.xyzcheck)   
   c:EnableReviveLimit()

	--atkup
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetCode(EFFECT_UPDATE_ATTACK)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetValue(s.atkval)
	-- c:RegisterEffect(e2)

	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e02=e0:Clone()
	e02:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e02)
	--damage val
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)

	--control
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(11508758,0))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetTarget(s.atktg2)
	e7:SetOperation(s.atkop2)
	c:RegisterEffect(e7)

	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(84013237,0))
	e9:SetProperty(0+EFFECT_FLAG_DAMAGE_STEP)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetHintTiming(TIMING_BATTLE_PHASE)
	e9:SetCondition(s.atkcon3)
	e9:SetCost(s.atkcost3)
	e9:SetOperation(s.atkop3)
	c:RegisterEffect(e9,false,EFFECT_MARKER_DETACH_XMAT)

	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_ATKCHANGE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_ATTACK_DISABLED)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e10:SetTarget(s.target)
	e10:SetOperation(s.operation)
	c:RegisterEffect(e10)
end
s.xyz_number=0
s.listed_series = {0x48}
s.listed_names={65305468}

function s.mfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp)
end
function s.xyzcheck(g)
	local mg=g:Filter(function(c) return not c:IsHasEffect(EFFECT_EQUIP_SPELL_XYZ_MAT) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end

function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	local p=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetLocationCount(p,LOCATION_MZONE)>0 and tc~=nil and tc:IsControler(1-p) end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	if Duel.GetLocationCount(p,LOCATION_MZONE)==0 then return end
	local tc=e:GetHandler():GetBattleTarget()
	Duel.GetControl(tc,p,EVENT_PHASE+PHASE_BATTLE,1)
end
function s.spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(s.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>1
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local g=nil
	local sg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,s.mfilter,2,2,nil)
		local tc1=g:GetFirst()
			local tc2=g:GetNext()
			sg:Merge(tc1:GetOverlayGroup())
		sg:Merge(tc2:GetOverlayGroup())
	end
	Duel.Overlay(c,sg)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and not c:IsSetCard(0x48)
end
function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,65305468)
end
function s.atkfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*300
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsFaceup() and eg:GetFirst():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg:GetFirst())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(s.chainatk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(tc:GetAttack()*2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e3)
	end
end
function s.chainatk(e)
	local c=e:GetHandler()
	return c:GetEffectCount(EFFECT_EXTRA_ATTACK)
end

function s.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
	  and not c:IsStatus(STATUS_CHAINING) 
	  and Duel.GetAttacker()~=nil and Duel.GetAttacker():CanAttack() and not Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED) 
end
function s.atkcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end