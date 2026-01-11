--シューティング·クェーサー·ドラゴン
Duel.EnableUnofficialProc(PROC_CANNOT_BATTLE_INDES)
local s, id = GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),2,99)
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)

	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.mtcon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_SINGLE)
	e32:SetCode(EFFECT_MATERIAL_CHECK)
	e32:SetValue(s.valcheck)
	e32:SetLabelObject(e2)
	c:RegisterEffect(e32)

	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(s.damval)
	c:RegisterEffect(e3)

	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35952884,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.sumcon)
	e4:SetTarget(s.sumtg)
	e4:SetOperation(s.sumop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BATTLE_INDES)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.battg)
	e5:SetValue(s.batval)
	c:RegisterEffect(e5)

	-- local e9=Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_INITIAL)
	-- e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_BATTLED)
	-- e9:SetRange(LOCATION_MZONE)
	-- e9:SetCondition(s.con)
	-- e9:SetOperation(s.op)
	-- c:RegisterEffect(e9)

	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetValue(s.efilter)
	c:RegisterEffect(e10)
	
	--synchro effect
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(50091196,1))
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_UNCOPYABLE)  
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)  
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(s.sccon)
	e8:SetTarget(s.sctarg)
	e8:SetOperation(s.scop)
	c:RegisterEffect(e8)
end
s.listed_names={24696097}

function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()>0
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttp=c:GetControler()
	local ct=e:GetLabel()
	if count==0 then ct=1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(ct-1)
	c:RegisterEffect(e1)
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetCount()
	e:GetLabelObject():SetLabel(ct)
end

function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	  local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
	  and Duel.GetAttacker()==e:GetHandler() and (ph>=PHASE_BATTLE and ph<=PHASE_DAMAGE_CAL)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function s.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c,e,tp)
	return c:GetCode()==24696097 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	  local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	  local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	  if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
	if tg~=nil and Duel.SelectYesNo(tp,aux.Stringid(35952884,1)) then
		Duel.SpecialSummonStep(tg,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
	end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  if Duel.GetAttacker()~=nil and Duel.GetAttackTarget()~=nil then
	  local bc=c
	  if Duel.GetAttacker()==c then
	bc=Duel.GetAttackTarget() end
	  if Duel.GetAttackTarget()==c then
	bc=Duel.GetAttacker() end
	if bc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
			local e11=e1:Clone()
		e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		bc:RegisterEffect(e11)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DAMAGE_STEP_END)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(s.resetop)
		e2:SetLabelObject(e1)
		bc:RegisterEffect(e2)
			local e21=e2:Clone()
		e21:SetLabelObject(e11)
		bc:RegisterEffect(e21) end end  
end

--Immune
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttacker()
	  return d~=nil and d==e:GetHandler()
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_EFFECT)
end
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end

function s.battg(e,c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.batval(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- function s.con(e)
-- 	local c=e:GetHandler()
-- 	local atk=c:GetAttack()
-- 	local bc=c:GetBattleTarget()
-- 	if not bc then return end
-- 	local bct=0
-- 	if bc:GetPosition()==POS_FACEUP_ATTACK then
-- 		bct=bc:GetAttack()
-- 	else bct=bc:GetDefense()+1 end
-- 	return c:IsRelateToBattle() and c:GetPosition()==POS_FACEUP_ATTACK 
-- 	 and atk>=bct and not bc:IsStatus(STATUS_DESTROY_CONFIRMED)
-- end 
-- function s.op(e,tp,eg,ep,ev,re,r,rp)
-- 	local bc=e:GetHandler():GetBattleTarget()
-- 	Duel.Destroy(bc,REASON_RULE)
-- 	bc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
-- end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
end
function s.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSynchroSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SynchroSummon(tp,c,nil)
	end 
end