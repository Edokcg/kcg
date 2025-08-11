--ゴッドアイズ・ファントム・ドラゴン
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.atcon)
	e1:SetCost(s.atcost)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)

	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.penlimit)
	c:RegisterEffect(e2)

	--attack up
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(s.atkcon)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70335319,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetCondition(s.hspcon)
	e3:SetOperation(s.hspop)
	e3:SetValue(SUMMON_TYPE_SPECIAL+id)
	e3:SetLabelObject(e5)
	c:RegisterEffect(e3)

	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(70335319,1))
	e6:SetCategory(CATEGORY_NEGATE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.negcon)
	e6:SetCost(s.negcost)
	e6:SetTarget(s.negtg)
	e6:SetOperation(s.negop)
	c:RegisterEffect(e6)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)

	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_ATTACK_DISABLED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCondition(s.atknegcon)
	e7:SetOperation(s.operation)
	c:RegisterEffect(e7)

	if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

function s.penlimit(e,se,sp,st)
	return st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM and not e:GetHandler():IsLocation(LOCATION_HAND)
end

function s.check(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if s[2] and s[2]~=at then
		s[at:GetControler()]=1
		return
	end
	s[2]=at
end
function s.clear(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
	s[2]=nil
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and Duel.GetAttackTarget()~=nil
		and at:IsRace(RACE_DRAGON) and at:IsType(TYPE_PENDULUM) and at:CanChainAttack(0)
end
function s.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s[tp]==0 end
	local at=Duel.GetAttacker()
	at:RegisterFlagEffect(70335319,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.atktg(e,c)
	return c:GetFlagEffect(70335319)==0
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end


function s.hspfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp)
	return g:GetCount()>=1 and g:FilterCount(Card.IsReleasable,nil)==g:GetCount()
		and g:IsExists(s.hspfilter,1,nil)
		and (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
			or c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp,g,tp)>0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
	local g2=Duel.GetOperatedGroup()
	if g2:GetCount()<1 then return end
	local ae=e:GetLabelObject()
	ae:SetLabel(g2:FilterCount(Card.IsRace,nil,RACE_DRAGON))
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL+id)~=0 and e:GetLabel()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:GetLabel() and e:GetLabel()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		if bc and bc:IsFaceup() then
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_UPDATE_ATTACK)
		   e2:SetValue(-e:GetLabel()*1000)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		   bc:RegisterEffect(e2)
		end
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g<1 then return end
	Duel.SendtoGrave(g,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.cfilter2(c,code)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsCode(code)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		local g=Duel.GetMatchingGroup(s.cfilter2,tp,0,LOCATION_SZONE,ec,ec:GetCode())
		if g:GetCount()<1 then return end
		g:AddCard(ec)
		for tc in aux.Next(g) do
		   Duel.ChangePosition(tc,POS_FACEDOWN)
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_CANNOT_TRIGGER)
		   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e1)
		   Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end

function s.atknegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:GetFirst() and eg:GetFirst()==c
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
end

