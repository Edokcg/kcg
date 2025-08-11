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
	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(84013237,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(23776077,0))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCondition(s.thcon)
	e6:SetTarget(s.sptg2)   
	e6:SetOperation(s.operation3)
	c:RegisterEffect(e6)    

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

    local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.negcon)
	e9:SetTarget(s.negtg)
	e9:SetOperation(s.negop)
	c:RegisterEffect(e9)

	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(86238081,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(s.pencon)
	e8:SetTarget(s.pentg)
	e8:SetOperation(s.penop)
	c:RegisterEffect(e8)    

	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_PZONE)
	e10:SetHintTiming(0,TIMING_END_PHASE)
	e10:SetCountLimit(1)
	e10:SetOperation(s.negop2)
	c:RegisterEffect(e10)    

	aux.GlobalCheck(s,function() 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)  
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE+PHASE_DRAW)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.check2op)
		Duel.RegisterEffect(ge2,0)
	end)    
end

function s.penlimit(e,se,sp,st)
	return Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_FUSION)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_XYZ)>0 and Duel.GetMatchingGroupCount(s.ddfilter,sp,LOCATION_GRAVE,0,nil,TYPE_LINK)>0
end
function s.ddfilter(c,type)
	return c:IsType(type)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(1-tp,0)
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

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
                        end 
                    end 
                end 
            end
        end
    end
end 

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev) 
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0) 
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
                    end 
                end 
            end 
        end
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
end
function s.spfilter(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,loc,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function s.retfilter(c,tid)
	return c:GetFlagEffect(511010207)>0
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetMatchingGroup(s.retfilter,tp,0x9d,0x9d,nil)
	local tc2=g2:GetFirst()
	while tc2 do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc2:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc2:RegisterEffect(e2)
        Duel.AdjustInstantly()
        if tc2:GetFlagEffectLabel(511010208)==LOCATION_HAND then
            Duel.SendtoHand(tc2,tc2:GetFlagEffectLabel(511010209),REASON_EFFECT)
        elseif tc2:GetFlagEffectLabel(511010208)==LOCATION_GRAVE then
            Duel.SendtoGrave(tc2,REASON_EFFECT,tc2:GetFlagEffectLabel(511010209))
        elseif tc2:GetFlagEffectLabel(511010208)==LOCATION_REMOVED then
            Duel.Remove(tc2,tc2:GetPreviousPosition(),REASON_EFFECT,tc2:GetFlagEffectLabel(511010209))
        elseif tc2:GetFlagEffectLabel(511010208)==LOCATION_DECK then
            Duel.SendtoDeck(tc2,tc2:GetFlagEffectLabel(511010209),0,REASON_EFFECT)
        elseif tc2:GetFlagEffectLabel(511010208)==LOCATION_EXTRA then
            Duel.SendtoDeck(tc2,tc2:GetFlagEffectLabel(511010209),0,REASON_EFFECT)
        else
        if not tc2:IsImmuneToEffect(e) then
            Duel.MoveToField(tc2,tc2:GetFlagEffectLabel(511010209),tc2:GetFlagEffectLabel(511010209),tc2:GetFlagEffectLabel(511010208),tc2:GetFlagEffectLabel(511010210),true)
            Duel.MoveSequence(tc2,tc2:GetFlagEffectLabel(511010211)) end
        end
        tc2=g2:GetNext()
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc then
		rc:RegisterFlagEffect(511010207,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function s.check2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(511010208,RESET_PHASE+PHASE_END,0,1,tc:GetLocation())
			tc:RegisterFlagEffect(511010209,RESET_PHASE+PHASE_END,0,1,tc:GetControler())
			tc:RegisterFlagEffect(511010210,RESET_PHASE+PHASE_END,0,1,tc:GetPosition())
			tc:RegisterFlagEffect(511010211,RESET_PHASE+PHASE_END,0,1,tc:GetSequence())
			tc=g:GetNext()
		end
	end
end