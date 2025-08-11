--侵攻之神官
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRACE_DIVINE))
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--场上有幻神时破坏效果怪兽效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_END)
	e1:SetCondition(s.discon)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	--场上有幻神时可以连锁攻击
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10000073,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_END)
	e2:SetCondition(s.atcon)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end

function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_DIVINE) and (sumtp&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.filter(c,att)
	return c:IsFaceup() and c:IsRace(att)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,RACE_DIVINE)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2)
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:CanChainAttack()
		and not c:IsDisabled() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,RACE_DIVINE)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
