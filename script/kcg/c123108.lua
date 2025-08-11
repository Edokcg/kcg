--奧雷卡爾克斯之神
local s,id=GetID()
function s.initial_effect(c)
    aux.god(c,3,id,0)

    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(805)
    e1:SetValue(3)
    c:RegisterEffect(e1)

	c:EnableReviveLimit()

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)

	--activate
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e51:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e51:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e51:SetCode(EVENT_LEAVE_FIELD)
	e51:SetRange(LOCATION_EXTRA)
	e51:SetTarget(s.sptg2)
	e51:SetOperation(s.spop2)
	c:RegisterEffect(e51)

	  --Cannot Lose
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetCode(EFFECT_CANNOT_LOSE_LP)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(1,0)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	local e19=e18:Clone()
	e19:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e19)
	local e20=e18:Clone()
	e20:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e20)

	--extra damage	  
	local e7=Effect.CreateEffect(c)
  e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetTarget(s.tar)
	e7:SetCondition(s.rdcon2)
	e7:SetOperation(s.rdop2)
	e7:SetCountLimit(1)
	c:RegisterEffect(e7)

	local e1235=Effect.CreateEffect(c)
	e1235:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1235:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1235:SetCode(EVENT_LEAVE_FIELD)
	e1235:SetOperation(s.lose)
	c:RegisterEffect(e1235)
end
s.listed_names={123106}
s.listed_series={0x900}

function s.rdop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttp=c:GetControler()
	if Duel.GetBattleDamage(ttp)>=Duel.GetLP(ttp) then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(ttp)-1)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,ttp) end
end
function s.rdcon11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then 
		return true 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) 
end
function s.rdop112(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(tp)-1)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e3,tp) 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and cv>=Duel.GetLP(tp) then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(Duel.GetLP(tp)-1)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e3,tp) 
	end 
end
function s.dc(e)
local tp=e:GetOwner():GetControler()
return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1
end

function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  local ttp=c:GetControler()
	return (c==Duel.GetAttackTarget() or c==Duel.GetAttacker())
	  and c:GetAttack()>200000 and Duel.GetLP(1-ttp)>Duel.GetBattleDamage(1-ttp)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  local X=Duel.GetLP(1-tp)
	  local ttp=c:GetControler()
	  if c:GetAttack()>200000 and Duel.GetLP(1-ttp)>Duel.GetBattleDamage(1-ttp) then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(X)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,ttp) end
end

function s.rdcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and e:GetHandler()==Duel.GetAttacker()
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttackTarget()
	  local X=a:GetAttack()*2+2000
	  if chk==0 then return true end
	  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,1-tp,1,0,X)
	  Duel.SetOperationInfo(0,CATEGORY_RECOVER,tp,1,0,X)
end
function s.rdop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttackTarget()
	local X=a:GetAttack()*2+2000
	if Duel.Damage(1-tp,X,REASON_EFFECT)>0 then
	Duel.Recover(tp,X,REASON_EFFECT) end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsReason(REASON_DESTROY) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
				end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)

				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_ATTACK)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(2000)
				c:RegisterEffect(e2)
				Duel.BreakEffect() 
		end
end

function s.cfilter(c)
	   return c:IsSetCard(0x900) and c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function s.cfilter2(c,tp)
	return c:IsCode(123106) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spfilter(c,e,tp)
	return c:IsCode(123106) and (not c:IsLocation(LOCATION_MZONE) or c:IsControler(1-tp))
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.cfilter2,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())==0 then return end
	Duel.SpecialSummon(e:GetHandler(),1,tp,tp,true,true,POS_FACEUP)
end

function s.lose(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetHandler() 
	  local ttp=tc:GetOwner() 
	  local WIN_REASON_DIVINE_SERPENT=0x103
	  Duel.Win(1-ttp,WIN_REASON_DIVINE_SERPENT)
end