--虹天气 附属虹
function c1643.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1643,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,1643)
	e1:SetCondition(c1643.dspcon)
	e1:SetTarget(c1643.dsptg)
	e1:SetOperation(c1643.dspop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c1643.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1643,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(c1643.spcon)
	e3:SetTarget(c1643.sptg)
	e3:SetOperation(c1643.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c1643.spreg(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsReason(REASON_COST) and rc:IsSetCard(0x109) and c:IsPreviousLocation(LOCATION_ONFIELD) and re:IsActivated() then
		e:SetLabel(Duel.GetTurnCount()+1)
		c:RegisterFlagEffect(1643,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c1643.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(1643)>0
end
function c1643.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():ResetFlagEffect(1643)
end
function c1643.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1643.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x109)
end
function c1643.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1643.cfilter,1,nil,tp)
end
function c1643.dspfilter(c,e,tp,eg)
	return c:IsSetCard(0x109) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not eg:IsExists(Card.IsCode,1,nil,tp,c:GetCode())
end
function c1643.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1643.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1643.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1643.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


