--古代的机械改造士兵（neet）
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
 --indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.indcon)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	local e2=e0:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.aclimit)
	e4:SetCondition(s.actcon)
	c:RegisterEffect(e4)
--pierce
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e20)
end
function s.mfilter(c)
	return  c:IsRace(RACE_MACHINE)
end
function s.indcon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and #mg>0 and  mg:IsExists(s.mfilter,1,nil)
end
function s.atkval(e,c)
	return c:GetBaseAttack()*2
end

function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
