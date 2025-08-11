--碎魂者之驱逐(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.filter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xa70)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
