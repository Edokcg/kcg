--上古嗜血巨人(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
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
function s.spfilter(c)
return c:IsSetCard(0xa120) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)  
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,c)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
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