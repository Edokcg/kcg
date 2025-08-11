--闇黑死亡眼 (KA)
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)

	--immune
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	-- e1:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetTargetRange(LOCATION_SZONE,0)
	-- e1:SetCondition(s.condition)
	-- e1:SetValue(s.efilter)
	--c:RegisterEffect(e1)

	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(740)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetTargetRange(LOCATION_HAND,0)
	-- e3:SetCondition(s.condition)
	-- e3:SetTarget(s.tfilter)
	--c:RegisterEffect(e3)	

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetDescription(aux.Stringid(100000703,0))
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCountLimit(1)
	-- e2:SetCondition(s.ddcondition)
	-- e2:SetOperation(s.operation)
	--c:RegisterEffect(e2)

	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	  
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(s.sop)
	c:RegisterEffect(e8)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetOperation(s.operation2)
	c:RegisterEffect(e4)	
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e5) 

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(s.desop)
	e6:SetLabelObject(e8)
	c:RegisterEffect(e6)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_ATTACK_FINAL)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(s.aval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e10:SetValue(s.dval)
	c:RegisterEffect(e10)

	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(185,0))
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetTarget(s.rvtg)	
	e14:SetOperation(s.operation)
	c:RegisterEffect(e14)	

	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(185,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(s.retg)
	e7:SetOperation(s.reop)
	c:RegisterEffect(e7)
	
	local e18=Effect.CreateEffect(c)
	e18:SetDescription(aux.Stringid(185,2))
	e18:SetType(EFFECT_TYPE_QUICK_O)
	e18:SetCode(EVENT_FREE_CHAIN)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCountLimit(1)
	e18:SetTarget(s.retg2)
	e18:SetOperation(s.reop2)
	c:RegisterEffect(e18)	
end
s.listed_series={0x316}
s.listed_names={id}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.tfilter(e,c)
	return not c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end

function s.ddfilter(c)
	return not c:IsHasEffect(100000703) and c:IsFaceup() and c:IsCode(100000590)
end
function s.ddcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ddfilter,tp,LOCATION_SZONE,0,1,nil)
end

function s.rvtg(e,tp,ev,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
		if gdd:GetCount()<1 then return false end
		local gd=gdd:Filter(Card.IsFacedown,c)
		return gd:GetCount()>0
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,c)
	if #gd>0 then Duel.ConfirmCards(tp, gd) end
end

function s.sop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp)
end

function s.zfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tatk=0
	local g=Duel.GetMatchingGroup(s.zfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	  local atk=tc:GetAttack()
	  tatk=tatk+atk
	  tc=g:GetNext() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Duel.SetLP(tp,tatk)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local lp=te:GetLabel()
	Duel.SetLP(tp,lp)
end

function s.filter(c)
	return c:IsFaceup() and not c:IsCode(id)
end
function s.aval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if val>=0 then return val+1 end
	end
end
function s.dval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if val>=0 then return val+1 end
	end
end

function s.refilter(c)
	return c:GetSequence()<5
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
		if gdd:GetCount()<1 then return false end
		local gd=gdd:Filter(s.refilter,c)
		return gd:GetCount()>0
	end
end
function s.getflag(g,tp)
	local flag = 0
	for c in aux.Next(g) do
		flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
	end
	if tp~=0 then
		flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
	end
	return ~flag
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(s.refilter,c)
	if gd:GetCount()<1 then return end
	local g=gd:Filter(Card.IsControler,c,tp)
	local g2=gd:Filter(Card.IsControler,c,1-tp)
	if #g<1 and #g2<1 then return end
	local ag=g
	ag:Merge(g2)
	local try=1
	local filter=0 local filter2=0
	while #ag>0 do
		if try==0 and not Duel.SelectYesNo(tp, aux.Stringid(185,1)) then break end
		try=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local p=ag:Select(tp,1,1,nil):GetFirst()
		local ttp=p:GetControler()
		--s.getflag(ag,ttp)
		local afilter=0	
		ag:RemoveCard(p)	
		if ttp==tp then 
			g:RemoveCard(p)
			afilter=filter|(0x100<<p:GetSequence())|0xffffe0ff
		else 
			g2:RemoveCard(p) 
			afilter=filter2|(0x100<<p:GetSequence()<<16)|0xe0ffffff
		end				
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone
		if ttp==tp then 
			zone=Duel.SelectFieldZone(tp,1,LOCATION_SZONE,0,afilter)
			--filter=filter|zone
		else 
			zone=Duel.SelectFieldZone(tp,1,0,LOCATION_SZONE,afilter)
			--filter2=filter2|zone 
			zone=zone>>16
		end
		local seq=math.log(zone>>8,2)
		local oc=Duel.GetFieldCard(ttp,LOCATION_SZONE,seq)
		if oc then
			Duel.SwapSequence(p,oc)
		else
			Duel.MoveSequence(p,seq)
		end	
	end
end

function s.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function s.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(s.setfilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function s.reop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local p=g:Select(tp,1,99,nil)
	for ap in aux.Next(p) do
	    Duel.ChangePosition(ap, POS_FACEDOWN)
		Duel.RaiseEvent(ap,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ap:RegisterEffect(e1)
	end	
end