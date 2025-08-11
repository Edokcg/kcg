--反盗墓(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)	
end
function s.tgfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tgfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(c)
	return c:IsSpellTrap() and c:IsSSetable()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT) then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,0,LOCATION_GRAVE,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE,1,nil)
		if b1 or b2 then
			Duel.BreakEffect()
			local op=Duel.SelectEffect(tp,
				{b1,aux.Stringid(id,0)},
				{b2,aux.Stringid(id,1)})
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
			if op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil)
				Duel.SSet(tp,g)
			end
		end
	end
end