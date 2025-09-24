--Mirror Force Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,11082056,44095762)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e00)
	
	--Mirror Force blast!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.material_trap=44095762
s.listed_names={44095762,11082056}

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and bc:GetAttack()>=c:GetAttack()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(96864105)==0 and
	Duel.IsExistingMatchingCard(s.filter1,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) 
	end
	local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gs,gs:GetCount(),0,0)
	c:RegisterFlagEffect(96864105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local dg=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil,c:GetAttack())
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
	e4:SetCondition(s.rdcon)
	e4:SetOperation(s.rdop)
	  e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(s.op2)
	  e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e3)
end

function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil,c:GetAttack())
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

function s.filter1(c,atk)
	  return c:IsFaceup() and c:GetAttack()<atk and c:IsPosition(POS_FACEUP_ATTACK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	  local gs=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(gs,REASON_EFFECT)
end
