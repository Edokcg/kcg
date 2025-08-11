--地缚 力的集约(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate2) 
	c:RegisterEffect(e1)
end
function s.cosfilter(c)
return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x21) and c:IsAbleToRemoveAsCost()
end
function s.filter(c,e,sp)
	return c:IsSetCard(0x21) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false,POS_FACEUP_ATTACK)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cosfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cosfilter,tp,LOCATION_MZONE,0,1,1,nil)
	 Duel.Remove(g,POS_FACEUP,REASON_COST)
	--Negate
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCondition(s.condition)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	Duel.RegisterEffect(e5,tp)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)  then
			Duel.BreakEffect()
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft<=0 then return end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,ft,ft,nil,e,tp)
			if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
				tc=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
