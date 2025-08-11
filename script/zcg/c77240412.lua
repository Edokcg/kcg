--上古魔鱼(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(s.valcon)
	c:RegisterEffect(e2)
				 --immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
end
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function s.spfilter(c)
return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa120)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(s.spfilter,c:GetControler(),LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end