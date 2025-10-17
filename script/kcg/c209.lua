local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedureX(c,s.mfilter,nil,2,nil,nil,nil,nil,false)

	  --special summon 
	--   local e0=Effect.CreateEffect(c) 
	--   e0:SetType(EFFECT_TYPE_FIELD)
	--   e0:SetCode(EFFECT_SPSUMMON_PROC) 
	--   e0:SetProperty(EFFECT_FLAG_UNCOPYABLE) 
	--   e0:SetRange(LOCATION_EXTRA) 
	--   e0:SetValue(SUMMON_TYPE_XYZ)
	--   e0:SetCondition(s.spcon) 
	--   e0:SetOperation(s.spop) 
	  -- c:RegisterEffect(e0) 

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)

	--control
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11508758,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)

	--prevent destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(13719,12))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	--e8:SetProperty(0)   
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetHintTiming(0,TIMING_END_PHASE)
	e8:SetCost(Cost.AND(Cost.DetachFromSelf(1),s.cost))
	e8:SetOperation(s.operation2)
	c:RegisterEffect(e8)
	--prevent effect damage
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(13719,13))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	--e9:SetProperty(0)   
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetCost(Cost.AND(Cost.DetachFromSelf(1),s.cost))
	e9:SetOperation(s.operation3)
	c:RegisterEffect(e9)
end
s.xyz_number=0
s.listed_series = {0x48}

function s.mfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048)
end

-- function s.spcon(e,c,og)
-- 	if c==nil then return true end
-- 	local tp=c:GetControler()
-- 	local mg=nil
-- 	if og then
-- 		mg=og:Filter(s.mfilter,nil,c)
-- 	else
-- 		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil,c)
-- 	end
-- 	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
-- 		and mg:GetCount()>1
-- end
-- function s.spop(e,tp,eg,ep,ev,re,r,rp,c,og)
-- 	local g=nil
-- 	local sg=Group.CreateGroup()
-- 	if og then
-- 		g=og
-- 		local tc=og:GetFirst()
-- 		while tc do
-- 			sg:Merge(tc:GetOverlayGroup())
-- 			tc=og:GetNext()
-- 		end
-- 	else
-- 		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
-- 		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
-- 		g=mg:FilterSelect(tp,s.mfilter,2,2,nil)
-- 		local tc1=g:GetFirst()
-- 			local tc2=g:GetNext()
-- 			sg:Merge(tc1:GetOverlayGroup())
-- 		sg:Merge(tc2:GetOverlayGroup())
-- 	end
-- 	Duel.Overlay(c,sg)
-- 	c:SetMaterial(g)
-- 	Duel.Overlay(c,g)
-- end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,bc,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.GetControl(bc,tp,PHASE_BATTLE,1)
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.etarget)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
end
 function s.etarget(e,c)
	return c:IsFaceup() and c==e:GetHandler()
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end