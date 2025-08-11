--上古死神(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(s.cond)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
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
function s.cond(e)
	return not Duel.IsExistingMatchingCard(Card.IsAttribute,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE)
end
function s.indes2(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
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