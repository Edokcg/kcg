--救祓少女·伊雷菲娅
function c1629.initial_effect(c)
	--xyz summon
   c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.mfilter,4,2)
	--spsummon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1629,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1629)
	e1:SetCost(c1629.spcost)
	e1:SetTarget(c1629.sptg)
	e1:SetOperation(c1629.spop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1629,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,1629,EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c1629.spcost1)
	e2:SetCondition(c1629.spcon1)
	e2:SetTarget(c1629.sptg1)
	e2:SetOperation(c1629.spop1)
	c:RegisterEffect(e2)
	--indes effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c1629.indval)
	c:RegisterEffect(e3)
end
function s.mfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_SPELLCASTER,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,lc,sumtype,tp)
end
function c1629.indval(e,te)
	return te:IsActivated() and te:GetHandler():IsSummonLocation(LOCATION_GRAVE)
end
function c1629.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1629.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1629.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(c1629.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c1629.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c1629.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local og=Duel.SelectTarget(tp,c1629.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	sg:Merge(og)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
end
function c1629.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local tc=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP)
			tc:RegisterFlagEffect(1629,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		g:KeepAlive()
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c1629.rmcon)
		e1:SetOperation(c1629.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1629.rmfilter(c,fid)
	return c:GetFlagEffectLabel(1629)==fid
end
function c1629.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1629.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1629.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c1629.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
function c1629.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c1629.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))
end
function c1629.spfilter1(c,e,tp)
	return c:IsCode(79858629) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1629.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp)
end
function c1629.spfilter2(c,e,tp)
	return c:IsCode(5352328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1629.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(c1629.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function c1629.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c1629.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c1629.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
