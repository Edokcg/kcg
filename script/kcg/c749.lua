--闇黑死亡眼 (KA)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--cannot special summon
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e01)

		--special summon 
		local e00=Effect.CreateEffect(c)  
		e00:SetType(EFFECT_TYPE_FIELD) 
		e00:SetCode(EFFECT_SPSUMMON_PROC)  
		e00:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
		e00:SetRange(LOCATION_EXTRA)  
		e00:SetCondition(s.spcon)  
		e00:SetOperation(s.spop)  
		e00:SetValue(SUMMON_TYPE_XYZ)
		c:RegisterEffect(e00) 

	  --special summon
	local e02=Effect.CreateEffect(c)
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e02:SetRange(LOCATION_EXTRA)
	e02:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e02:SetCode(EVENT_TO_GRAVE)
	e02:SetCondition(s.sprcon)
	e02:SetTarget(s.sprtg)
	e02:SetOperation(s.sprop)
	c:RegisterEffect(e02)   

	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(s.condition)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)

	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD)
	-- e3:SetCode(740)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetTargetRange(LOCATION_HAND,0)
	-- e3:SetCondition(s.condition)
	-- e3:SetTarget(s.tfilter)
	-- c:RegisterEffect(e3) 

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetDescription(aux.Stringid(100000703,0))
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCountLimit(1)
	-- e2:SetCondition(s.ddcondition)
	-- e2:SetOperation(s.operation)
	--c:RegisterEffect(e2)

	  local e4=Effect.CreateEffect(c)
	  e4:SetType(EFFECT_TYPE_FIELD)
	  e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	  e4:SetRange(LOCATION_MZONE)
	  e4:SetTargetRange(0,1)
	  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e4:SetTarget(s.splimit)
	  c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetValue(s.lp)
	c:RegisterEffect(e5)

	--attack cost
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(24696097,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(s.atkcost)
	e6:SetCondition(s.atkcon)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6,false,EFFECT_MARKER_DETACH_XMAT)

	--multiattack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_EXTRA_ATTACK)
	e8:SetValue(s.atkvalue)
	c:RegisterEffect(e8) 

	--Re-Attach
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(79094383,0))
	e7:SetCategory(CATEGORY_LEAVE_GRAVE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.recost)
	e7:SetCondition(s.recondition)
	e7:SetTarget(s.retarget)
	e7:SetOperation(s.reoperation)
	c:RegisterEffect(e7)

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
s.listed_names={746,747,748}

function s.spcon(e,c)
		if c==nil then return true end
		return Duel.IsExistingMatchingCard(s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c,746)
		and Duel.IsExistingMatchingCard(s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c,747)
		and Duel.IsExistingMatchingCard(s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c,748)
end
function s.ovfilter(c,tc,code)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(tc) and c:IsCode(code)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg1=Duel.SelectMatchingCard(tp,s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c,746)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg2=Duel.SelectMatchingCard(tp,s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c,747)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg3=Duel.SelectMatchingCard(tp,s.ovfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c,748)
		local tg=Group.CreateGroup()
		tg:Merge(tg1) tg:Merge(tg2) tg:Merge(tg3)
		local ag=tg
		local tc=tg:GetFirst()
		while tc do
		local ttc=tc:GetOverlayGroup()
		if ttc~=nil then
		local btc=ttc:GetFirst()
		while btc do
		Duel.Overlay(e:GetHandler(),btc)
		btc=ttc:GetNext() end end
		Duel.Overlay(e:GetHandler(),tc)
		ag:Merge(ttc)
		tc=tg:GetNext() end
		c:SetMaterial(tg)
end

function s.cfilter(c,tp,code)
	return c:IsCode(code) and c:IsReason(REASON_DESTROY)
end
function s.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,511310100)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and eg:IsExists(s.cfilter,1,nil,tp,511310100) then
	local g=eg:Filter(s.cfilter,nil,tp,511310100)
	e:GetHandler():SetMaterial(g)
	Duel.Overlay(e:GetHandler(),g)
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
	e:GetHandler():CompleteProcedure() end
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

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype==SUMMON_TYPE_XYZ or sumtype==SUMMON_TYPE_SYNCHRO or sumtype==SUMMON_TYPE_FUSION
end

function s.lp(e)
	if Duel.GetLP(e:GetHandlerPlayer())<=8000 then return 8000-Duel.GetLP(e:GetHandlerPlayer())
	else return Duel.GetLP(e:GetHandlerPlayer())-8000 end
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():GetFlagEffect(749)==0
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Avoid allow activate during attack
	c:RegisterFlagEffect(749,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE,0,1)
	c:RegisterFlagEffect(748,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE,0,1)
	local e10=Effect.CreateEffect(c)   
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_DAMAGE_STEP_END)
	e10:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
	e10:SetOperation(s.resetop)
	c:RegisterEffect(e10) 
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetFlagEffect(749)~=0 then
	e:GetHandler():ResetFlagEffect(749) end
end

function s.atkvalue(e,c) 
	return e:GetHandler():GetFlagEffect(748)
end

function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.recondition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.refilter(c,e,tp)
	return c:GetTurnID()==Duel.GetTurnCount()-1 and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsSetCard(0x316)
end
function s.retarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function s.reoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
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