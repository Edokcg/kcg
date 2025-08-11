local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	c:EnableReviveLimit()

	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.penlimit)
	c:RegisterEffect(e0)

	local e00=Effect.CreateEffect(c)
	e00:SetDescription(aux.Stringid(id,0))
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e00:SetCondition(s.spcon)
	c:RegisterEffect(e00)

	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.damcon)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)
	
	--reduce tribute
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(40227329,0))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.ntcon)
	e7:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e7)

	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(s.atcon)
	e3:SetCost(s.atcost)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)	
	
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
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84013237,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(23776077,0))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.sptg2)   
	e5:SetOperation(s.operation3)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)   

	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(s.pdstg)
	e8:SetOperation(s.pdsop)
	c:RegisterEffect(e8) 
end

function s.penlimit(e,se,sp,st)
	return Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_FUSION)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_XYZ)>0
end
function s.ddfilter(c,type)
	return c:IsType(type)
end

function s.spcon(e)
    local sp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_FUSION)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_XYZ)>0
end

function s.damcon(e)
	return e:GetHandler():GetFlagEffect(40227329)==0
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT)~=0 and c:GetFlagEffect(40227329)==0 then
		c:RegisterFlagEffect(40227329,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end

function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(5)
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

function s.filter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED)
	  and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
	Duel.NegateAttack()
	if Duel.GetCurrentPhase()<PHASE_END then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	if Duel.GetCurrentPhase()<PHASE_MAIN2 then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	if Duel.GetCurrentPhase()<PHASE_BATTLE then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)  
	if Duel.GetCurrentPhase()<PHASE_MAIN1 then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_DRAW,RESET_PHASE+PHASE_END,1)  
	if Duel.GetCurrentPhase()<PHASE_DRAW then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
	end end end end end
	end
end 

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev) 
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0) 
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
	Duel.NegateEffect(ev)
	if Duel.GetCurrentPhase()<PHASE_END then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	if Duel.GetCurrentPhase()<PHASE_MAIN2 then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	if Duel.GetCurrentPhase()<PHASE_BATTLE then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)  
	if Duel.GetCurrentPhase()<PHASE_MAIN1 then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_DRAW,RESET_PHASE+PHASE_END,1)  
	if Duel.GetCurrentPhase()<PHASE_DRAW then
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
	end end end end end
	end
end 
	
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end

function s.pdstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return atk>0 and Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,atk,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.pdsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
