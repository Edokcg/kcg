--アルティマヤ・ツィオルキン
local s,id=GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(0)
    c:RegisterEffect(e0)

	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,0)

	--cannot be target
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(s.tgcon)
	e13:SetValue(Auxiliary.imval1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e14:SetValue(1)
	c:RegisterEffect(e14)

	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e15:SetCountLimit(1)
	e15:SetValue(1)
	c:RegisterEffect(e15)

	--atk up
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(96864105,0))
	e16:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCondition(s.atkcon)
	e16:SetCost(s.atkcost)
	e16:SetTarget(s.atktarget)
	e16:SetOperation(s.atkop)
	c:RegisterEffect(e16)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1686814,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MSET)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SSET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.chkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_MSET)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(1,1)
	e10:SetTarget(s.setlimit)
	e10:SetLabelObject(e6)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e11)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetTarget(s.sumlimit)
	c:RegisterEffect(e12)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND|RACE_DRAGON)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e115)
end

function s.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLevelBelow(10) and c:GetLevel()>0
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end

function s.tgfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler() and (d==e:GetHandler() or a==e:GetHandler())
	and not Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(96864105)==0 end
	c:RegisterFlagEffect(96864105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.setfilter(c)
	return c:IsFacedown()
end
function s.atktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	  if Duel.IsExistingMatchingCard(s.setfilter,tp,0,LOCATION_SZONE,1,nil) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	  local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetOwnerPlayer(tp)
	  e1:SetCode(EFFECT_SET_ATTACK)
	  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	  e1:SetValue(d:GetAttack())
	  e:GetHandler():RegisterEffect(e1)
	  Duel.BreakEffect()
	  if Duel.IsExistingMatchingCard(s.setfilter,tp,0,LOCATION_SZONE,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,0,LOCATION_SZONE,1,1,nil)
	  Duel.Destroy(g:GetFirst(),REASON_EFFECT) end
end

function s.spfilter(c,e,tp,ct)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsRace(RACE_DRAGON) and c:IsLevelBelow(10) and c:IsType(TYPE_SYNCHRO))
		and (not ct or Duel.GetLocationCountFromEx(tp,tp,nil,c)>=ct)
end
function s.cfilter(c,p)
	return c:IsFacedown() and c:IsControler(p)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(s.cfilter,nil,tp)
	if ct>1 and (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(ct)) then ct=0 end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,ct,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(s.cfilter,nil,tp)
	if ct>1 and (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(ct)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,ct,ct,nil,e,tp,ct)
	if #g==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if eg:IsExists(s.cfilter,1,nil,i) then
			Duel.RegisterFlagEffect(i,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.setlimit(e,c,tp)
	return not c:IsLocation(LOCATION_ONFIELD) and Duel.GetFlagEffect(tp,id)>0
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_FACEDOWN==POS_FACEDOWN and not c:IsLocation(LOCATION_ONFIELD) and Duel.GetFlagEffect(sump,id)>0
end