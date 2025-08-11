--Numeron Rewriting Xyz
function c13710.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97836203,2))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c13710.condition4)
	e1:SetTarget(c13710.target4)
	e1:SetOperation(c13710.activate4)
	c:RegisterEffect(e1)
end
function c13710.condition4(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetSummonType()==SUMMON_TYPE_XYZ and tc:GetOverlayCount()>0
	and tc:IsControler(1-tp) 
end
function c13710.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c13710.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) 
end
function c13710.activate4(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg:GetFirst())
	if Duel.Destroy(eg,REASON_EFFECT)>0 then
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c13710.filter,tp,0,LOCATION_DECK,1,nil,e,tp) then  
	local g=Duel.GetMatchingGroup(c13710.filter,tp,0,LOCATION_DECK,nil,e,tp)
	Duel.ConfirmCards(tp,g) 
	local g2=g:Select(tp,1,1,nil)
	Duel.ShuffleDeck(1-tp)
	local tc=g2:GetFirst()
	if tc then 
		Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		--cannot trigger
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e3,true)
	  Duel.SpecialSummonComplete()
	  Duel.ShuffleDeck(1-tp) end
	  end end
end 