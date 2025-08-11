--闇黑死亡眼 (KA)
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcFunRep(c,s.mat_filter2,2,true)
	c:EnableReviveLimit()

	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
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

	-- local e41=Effect.CreateEffect(c)
	-- e41:SetType(EFFECT_TYPE_FIELD)
	-- e41:SetCode(740)
	-- e41:SetRange(LOCATION_MZONE)
	-- e41:SetTargetRange(LOCATION_HAND,0)
	-- e41:SetCondition(s.condition)
	-- e41:SetTarget(s.tfilter)
	--c:RegisterEffect(e41)   

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetDescription(aux.Stringid(100000703,0))
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCountLimit(1)
	-- e2:SetCondition(s.ddcondition)
	-- e2:SetOperation(s.operation)
	--c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15240238,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descondition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)

	-- local e40=Effect.CreateEffect(c)
	-- e40:SetType(EFFECT_TYPE_FIELD)
	-- e40:SetCode(740)
	-- e40:SetRange(LOCATION_MZONE)
	-- e40:SetTargetRange(LOCATION_SZONE,0)
	-- e40:SetTarget(s.tfilter2)
	-- c:RegisterEffect(e40)

	-- local e06=Effect.CreateEffect(c)
	-- e06:SetType(EFFECT_TYPE_FIELD)
	-- e06:SetCode(100000703)
	-- e06:SetRange(LOCATION_MZONE)
	-- e06:SetTargetRange(LOCATION_ONFIELD,0)
	-- c:RegisterEffect(e06)	

	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(185,0))
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetTarget(s.rvtg)	
	e14:SetOperation(s.operation)
	c:RegisterEffect(e14)

	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(185,1))
	e17:SetType(EFFECT_TYPE_QUICK_O)
	e17:SetCode(EVENT_FREE_CHAIN)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1)
	e17:SetTarget(s.retg)
	e17:SetOperation(s.reop)
	c:RegisterEffect(e17)
	
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

function s.mat_filter2(c)
  return c:IsSetCard(0x316) and c:GetLevel()>=7
end

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

function s.descondition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	local eb,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if eb and tg and tg:IsContains(e:GetHandler()) then return true end
	return eb and tg and tg:IsContains(e:GetHandler())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local sum=dg:GetSum(Card.GetAttack)
		Duel.Damage(1-tp,sum,REASON_EFFECT)
	end
end

function s.tfilter2(e,c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x316)
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