--传说骑士 克里提钨斯(ZCG)
function c77240203.initial_effect(c)
    c:EnableReviveLimit()
    --cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77240203.efilter)
	c:RegisterEffect(e1)

    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c77240203.sumsuc)
    c:RegisterEffect(e2)

    --Mirror Force blast!
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetTarget(c77240203.tg)
	e3:SetOperation(c77240203.op)
	c:RegisterEffect(e3)

    --sendcard
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c77240203.activate)
	c:RegisterEffect(e4)
end

function c77240203.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsControler(1-(e:GetHandler():GetOwner()))
end

function c77240203.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c77240203.distg)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c77240203.disop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c77240203.aclimit)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e3,tp)
end

function c77240203.distg(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_TRAP)
end

function c77240203.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end

function c77240203.aclimit(e,re,tp)
    return re:GetHandler():IsType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end

function c77240203.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup()
end

function c77240203.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(96864105)==0 and
	Duel.IsExistingMatchingCard(c77240203.filter1,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
	end
	local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gs,gs:GetCount(),0,0)
	c:RegisterFlagEffect(96864105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end

function c77240203.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local dg=Duel.GetMatchingGroup(c77240203.filter1,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	local tatk=0
	local tc=dg:GetFirst()
	while tc do
	local atk=c:GetAttack()-tc:GetAttack()
	tatk=tatk+atk
	tc=dg:GetNext() end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c77240203.rdcon)
	e4:SetOperation(c77240203.rdop)
	e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(c77240203.op2)
	e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e3)
end

function c77240203.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end

function c77240203.rdop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(c77240203.filter1,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	  local tatk=0
	  local tc=dg:GetFirst()
	  while tc do
	  local atk=c:GetAttack()-tc:GetAttack()
	  tatk=tatk+atk
	tc=dg:GetNext() end
	Duel.ChangeBattleDamage(1-tp,tatk,false)
	   c:RegisterFlagEffect(283,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	   c:SetFlagEffectLabel(283,tatk)
end

function c77240203.filter1(c,atk)
    return c:IsFaceup() and c:GetAttack()<atk and c:IsPosition(POS_FACEUP_ATTACK)
end

function c77240203.op2(e,tp,eg,ep,ev,re,r,rp)
    local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
  Duel.Destroy(gs,REASON_EFFECT)
end

function c77240203.desfilter(c,rc)
    return c:IsType(TYPE_TRAP)
end

function c77240203.activate(e,tp,eg,ep,ev,re,r,rp,c)
    local tg=Duel.SelectMatchingCard(tp,c77240203.desfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SendtoHand(tg,tp,REASON_EFFECT)
end
