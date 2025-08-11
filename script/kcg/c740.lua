--闇黑死亡眼 (KA)
function c740.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--immune
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	-- e1:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetTargetRange(LOCATION_SZONE,0)
	-- e1:SetCondition(c740.condition)
	-- e1:SetValue(c740.efilter)
	--c:RegisterEffect(e1)

	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(740)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetTargetRange(LOCATION_HAND,0)
	-- e3:SetCondition(c740.condition)
	-- e3:SetTarget(c740.tfilter)
	--c:RegisterEffect(e3)	

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetDescription(aux.Stringid(100000703,0))
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCountLimit(1)
	-- e2:SetCondition(c740.ddcondition)
	-- e2:SetOperation(c740.operation)
	--c:RegisterEffect(e2)

	-- local e4=Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_FIELD)
	-- e4:SetCode(740)
	-- e4:SetRange(LOCATION_MZONE)
	-- e4:SetTargetRange(LOCATION_SZONE,0)
	-- e4:SetTarget(c740.tfilter2)
	-- c:RegisterEffect(e4)

	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DISABLE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c740.condition2)
	e6:SetTarget(c740.target)
	e6:SetOperation(c740.activate2)
	c:RegisterEffect(e6)

	-- local e7=Effect.CreateEffect(c)
	-- e7:SetDescription(aux.Stringid(185,1))
	-- e7:SetType(EFFECT_TYPE_QUICK_O)
	-- e7:SetCode(EVENT_FREE_CHAIN)
	-- e7:SetRange(LOCATION_MZONE)
	-- e7:SetCountLimit(1)
	-- e7:SetTarget(c740.retg)
	-- e7:SetOperation(c740.reop)
	-- --c:RegisterEffect(e7)
	
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(185,2))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c740.retg2)
	e8:SetOperation(c740.reop2)
	--c:RegisterEffect(e8)

	-- local e7=Effect.CreateEffect(c)
	-- e7:SetType(EFFECT_TYPE_FIELD)
	-- e7:SetCode(100000703)
	-- e7:SetRange(LOCATION_MZONE)
	-- e7:SetTargetRange(LOCATION_ONFIELD,0)
	-- c:RegisterEffect(e7)		
end

function c740.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end

function c740.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c740.tfilter(e,c)
	return not c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end

function c740.ddfilter(c)
	return not c:IsHasEffect(100000703) and c:IsFaceup() and c:IsCode(100000590)
end
function c740.ddcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c740.ddfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c740.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c740.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c740.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_DISABLE)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ec:RegisterEffect(e0)   
	end
end

function c740.tfilter2(e,c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x316)
end

function c740.refilter(c)
	return c:GetSequence()<5
end
function c740.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c740.refilter,tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(c740.refilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function c740.getflag(g,tp)
	local flag = 0
	for c in aux.Next(g) do
		flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
	end
	if tp~=0 then
		flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
	end
	return ~flag
end
function c740.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c740.refilter,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c740.refilter,1-tp,LOCATION_SZONE,0,nil)	
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
		--c740.getflag(ag,ttp)
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

function c740.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c740.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c740.setfilter,tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(c740.setfilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function c740.reop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c740.setfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
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

