--闇黑死亡眼 (KA)
function c745.initial_effect(c)
  if Card.IsFusionAttribute then
		Fusion.AddProcFunRep(c,c745.mat_filter1,2,true)
	else
		Fusion.AddProcFunRep(c,c745.mat_filter2,2,true)
	end
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCondition(c745.condition)
	e1:SetValue(c745.efilter)
	--c:RegisterEffect(e1)

	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(740)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetTargetRange(LOCATION_HAND,0)
	-- e3:SetCondition(c745.condition)
	-- e3:SetTarget(c745.tfilter)
	--c:RegisterEffect(e3)	

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000703,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c745.ddcondition)
	e2:SetOperation(c745.operation)
	--c:RegisterEffect(e2)

	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(90953320,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c745.drcon)
	e4:SetTarget(c745.drtg)
	e4:SetOperation(c745.drop)
	c:RegisterEffect(e4)

	-- local e40=Effect.CreateEffect(c)
	-- e40:SetType(EFFECT_TYPE_FIELD)
	-- e40:SetCode(740)
	-- e40:SetRange(LOCATION_MZONE)
	-- e40:SetTargetRange(LOCATION_SZONE,0)
	-- e40:SetTarget(c745.tfilter2)
	-- c:RegisterEffect(e40)

	-- local e06=Effect.CreateEffect(c)
	-- e06:SetType(EFFECT_TYPE_FIELD)
	-- e06:SetCode(100000703)
	-- e06:SetRange(LOCATION_MZONE)
	-- e06:SetTargetRange(LOCATION_ONFIELD,0)
	-- c:RegisterEffect(e06)	

	-- local e7=Effect.CreateEffect(c)
	-- e7:SetDescription(aux.Stringid(185,1))
	-- e7:SetType(EFFECT_TYPE_QUICK_O)
	-- e7:SetCode(EVENT_FREE_CHAIN)
	-- e7:SetRange(LOCATION_MZONE)
	-- e7:SetCountLimit(1)
	-- e7:SetTarget(c745.retg)
	-- e7:SetOperation(c745.reop)
	--c:RegisterEffect(e7)
	
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(185,2))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c745.retg2)
	e8:SetOperation(c745.reop2)
	--c:RegisterEffect(e8)	
end


function c745.mat_filter1(c)
  return c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c745.mat_filter2(c)
  return c:IsAttribute(ATTRIBUTE_DARK)
end

function c745.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end

function c745.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c745.tfilter(e,c)
	return not c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end

function c745.ddfilter(c)
	return not c:IsHasEffect(100000703) and c:IsFaceup() and c:IsCode(100000590)
end
function c745.ddcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c745.ddfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c745.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and ep==tp and tg~=e:GetHandler() 
	and (tg:IsSummonType(SUMMON_TYPE_SYNCHRO) or tg:IsSummonType(SUMMON_TYPE_XYZ) or tg:IsSummonType(SUMMON_TYPE_FUSION))
end
function c745.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c745.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c745.tfilter2(e,c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x316)
end

function c745.refilter(c)
	return c:GetSequence()<5
end
function c745.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c745.refilter,tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(c745.refilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function c745.getflag(g,tp)
	local flag = 0
	for c in aux.Next(g) do
		flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
	end
	if tp~=0 then
		flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
	end
	return ~flag
end
function c745.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c745.refilter,tp,LOCATION_SZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c745.refilter,1-tp,LOCATION_SZONE,0,nil)	
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
		--c745.getflag(ag,ttp)
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

function c745.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c745.retg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c745.setfilter,tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(c745.setfilter,1-tp,LOCATION_SZONE,0,1,nil) end
end
function c745.reop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c745.setfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
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