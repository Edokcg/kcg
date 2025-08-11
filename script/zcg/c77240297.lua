--装甲 兵临城下 （ZCG）
function c77240297.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCondition(c77240297.condition)
	e0:SetTarget(c77240297.target)
	e0:SetOperation(c77240297.activate)
	c:RegisterEffect(e0)
end
function c77240297.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end 
function c77240297.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240297.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT) 
end

