--Orichalcos Dexia
local s,id=GetID()
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

	--ATK Increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.attcon)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)

	--selfdestroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(s.descon)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)

	--Shunoros Debuf
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLED)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
s.listed_names={12399}

function s.attcon(e)
	local c=e:GetHandler()
	local bt=c:GetBattleTarget()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE_CAL or PHASE_DAMAGE or Duel.IsDamageCalculated()) and bt and c:IsRelateToBattle()
end
function s.adval(e,c)
	local c=e:GetHandler()
	local bt=c:GetBattleTarget()
	local ph=Duel.GetCurrentPhase()
	if (ph==PHASE_DAMAGE_CAL or PHASE_DAMAGE or Duel.IsDamageCalculated()) and c:IsRelateToBattle() and bt then
		if bt:IsAttackPos() then return bt:GetAttack()+300 end
		if bt:IsDefensePos() then return bt:GetDefense()+300 end
	end
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(12399)
end

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.desfilter(c)
	return c:IsFaceup() and c:IsCode(12399)
end

function s.descon(e)
	return not Duel.IsExistingMatchingCard(s.desfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
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
		e1:SetValue(-e:GetHandler():GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1) 
		end
	end
end
