--GO－DDD神零王ゼロゴッド・レイジ
local s, id = GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	
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

	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40227329,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.effcost)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_BE_BATTLE_TARGET)
	e8:SetOperation(s.atkop3)
	c:RegisterEffect(e8)

	--reduce tribute
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(40227329,4))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.ntcon)
	e7:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e7)
end
s.listed_series = {0xaf}

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
	return c:IsLevelAbove(5) and c:IsSetCard(0xaf)
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp)
	g:RemoveCard(e:GetHandler())
	if chk==0 then return g:GetCount()>=1 and g:FilterCount(Card.IsReleasable,nil)==g:GetCount() end
	Duel.Release(g,REASON_COST)
	local g1=Duel.GetOperatedGroup()
	if g1:GetCount()<1 then return end
	local g2=g1:Filter(Card.IsPreviousSetCard,nil,0x20af)
	if g2:GetCount()<1 then return end
	e:SetLabel(g2:GetCount())
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gcount=e:GetLabel()
	if gcount<1 then return end
	if gcount>0 then
		aux.RegisterClientHint(c,nil,tp,0,1,aux.Stringid(id,1),nil)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(s.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if gcount>1 then
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(id,6))
		e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS+EFFECT_FLAG_CLIENT_HINT)
		e8:SetCode(EVENT_ATTACK_ANNOUNCE)
		e8:SetOperation(s.atkop2)
		e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e8)
	end
	if gcount>2 then
		aux.RegisterClientHint(c,nil,tp,0,1,aux.Stringid(id,5),nil)
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)  
		local e1=e4:Clone()
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		c:RegisterEffect(e1)  
		local e2=e4:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_MATERIAL)
        e2:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
		c:RegisterEffect(e2)
		local e7=e4:Clone()
		e7:SetCode(EFFECT_UNRELEASABLE_EFFECT) 
		c:RegisterEffect(e7)
		local e10=e4:Clone()
		e10:SetCode(EFFECT_UNRELEASABLE_NONSUM) 
		c:RegisterEffect(e10)
		local e11=e4:Clone()
		e11:SetCode(EFFECT_UNRELEASABLE_SUM) 
		c:RegisterEffect(e11)
		local e8=e4:Clone()
		e8:SetCode(EFFECT_CANNOT_USE_AS_COST)
		c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD)
		e9:SetCode(EFFECT_HAND_LIMIT)
		e9:SetRange(LOCATION_MZONE)
		e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e9:SetTargetRange(0,1)
		e9:SetValue(100)
		c:RegisterEffect(e9)
		local e12=Effect.CreateEffect(c)
		e12:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e12:SetType(EFFECT_TYPE_FIELD)
		e12:SetCode(EFFECT_ASSUME_ZERO)
		e12:SetRange(LOCATION_MZONE)
		e12:SetTargetRange(0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
		e12:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e12)
	end
	if gcount>3 then
		local tg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.SendtoDeck(tg,0,-2,REASON_RULE+REASON_EFFECT)
	end
end
function s.aclimit1(e,re,tp)
	local rc=re:GetHandler()
	return rc and rc:IsLocation(LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE) and not rc:IsLocation(LOCATION_PZONE)
end

function s.efilter(e,te)
	return te~=e:GetLabelObject()
end

function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()  
	if at and at:IsFaceup() and at:IsControler(1-tp) and at:IsRelateToBattle() and at:GetAttack()>0 and not at:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(0)
	at:RegisterEffect(e1) 
	end
end
function s.atkop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	if at and at:IsFaceup() and at:IsControler(1-tp) and c==Duel.GetAttackTarget() and at:IsRelateToBattle() and at:GetAttack()>0 and not at:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(0)
	at:RegisterEffect(e1) 
	end
end

function s.aclimit1(e,re,tp)
	return re:GetActivateLocation()==LOCATION_SZONE or re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND
end
function s.aclimit2(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(1-tp,0)
end
