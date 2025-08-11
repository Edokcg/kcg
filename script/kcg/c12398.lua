--orichalcos Ariesteros
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.cbcon)
	e2:SetOperation(s.cbop)
	c:RegisterEffect(e2)

	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.attcon)
	e4:SetValue(s.adval)
	c:RegisterEffect(e4)

	--Shunoros Debuf
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

	--selfdestroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(s.descon)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end
s.listed_names={12399}

function s.desfilter(c)
	return c:IsCode(12399) and c:IsFaceup()
end
function s.descon(e)
	return not Duel.IsExistingMatchingCard(s.desfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return c~=bt and bt:GetControler()==c:GetControler()
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	if c~=bt and bt:GetControler()==c:GetControler() then
		Duel.ChangeAttackTarget(c)
	end
end

function s.attcon(e)
	local c=e:GetHandler()
	local bt=Duel.GetAttackTarget()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE_CAL or PHASE_DAMAGE or Duel.IsDamageCalculated()) and bt and c==bt and c:IsRelateToBattle()
end
function s.adval(e,c)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	local ph=Duel.GetCurrentPhase()
	if (ph==PHASE_DAMAGE_CAL or PHASE_DAMAGE or Duel.IsDamageCalculated()) and bt and c==bt and c:IsRelateToBattle() then 
		return a:GetAttack()+300 
	end
end

function s.filter(c)
	return c:IsFaceup() and c:IsCode(12399) and c:GetAttack()>0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-e:GetHandler():GetDefense())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1) 
		end
	end
end