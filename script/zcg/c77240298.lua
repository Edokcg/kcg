--装甲 绝地反击 （ZCG）
function c77240298.initial_effect(c)
		--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47027714,2))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA)
	e4:SetCondition(c77240298.spcon)
	e4:SetTarget(c77240298.sptg)
	e4:SetOperation(c77240298.spop)
	c:RegisterEffect(e4)
end
function c77240298.cfilter(c,tp,code)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
end
function c77240298.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240298.cfilter,1,nil,tp) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c77240298.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xa110)
end
function c77240298.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
		and Duel.IsExistingMatchingCard(c77240298.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77240298.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240298.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		end
end
