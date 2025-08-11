--神々の黄昏
function c121.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000535,4))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c121.target)
	e1:SetOperation(c121.operation)
	c:RegisterEffect(e1)
end
function c121.cfilter(c)
	local code=c:GetCode()
	return c:IsFaceup() and (c:IsCode(92377303, 30208479) or c:IsSetCard(0x10a2))
end
function c121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c121.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>1 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c121.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0x13,0,nil,TYPE_MONSTER)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
		local dg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
		Duel.Destroy(dg,REASON_RULE+REASON_EFFECT)
	end
end
