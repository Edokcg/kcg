--薰风的生灵 拉玛
function c1635.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1635,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1635)
	e1:SetCost(c1635.spcost)
	e1:SetTarget(c1635.sptg)
	e1:SetOperation(c1635.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1635,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1635)
	e2:SetCost(c1635.dspcost)
	e2:SetTarget(c1635.dsptg)
	e2:SetOperation(c1635.dspop)
	c:RegisterEffect(e2)
end
function c1635.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1635.spfilter1(c,e,tp)
	return c:IsSetCard(0x10) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1635.spfilter2(c,e,tp)
	return c:IsSetCard(0x10) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1635.fselect(g,e,tp)
	return g:FilterCount(c1635.spfilter1,nil,e,tp)==1 and g:FilterCount(c1635.spfilter2,nil,e,tp)==1 
		and Duel.IsExistingMatchingCard(c1635.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c1635.synfilter(c,g)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil,g)
end
function c1635.chkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1635.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return false end
		if Duel.GetMZoneCount(tp,e:GetHandler())<2 then return false end
		local cg=Duel.GetMatchingGroup(c1635.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(c1635.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:CheckSubGroup(c1635.fselect,2,2,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c1635.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
		local cg=Duel.GetMatchingGroup(c1635.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg>0 then
			local g=Duel.GetMatchingGroup(c1635.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,c1635.fselect,false,2,2,e,tp)
			if sg then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
			local og=Duel.GetOperatedGroup()
			Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
			if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
			local tg=Duel.GetMatchingGroup(c1635.synfilter,tp,LOCATION_EXTRA,0,nil,og)
			if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local rg=tg:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
			end
		end
	end
end
function c1635.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsDiscardable()
end
function c1635.dspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c1635.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c1635.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c1635.dspfilter(c,e,tp)
	return c:IsSetCard(0x10) and not c:IsCode(1635)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c1635.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1635.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1635.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c1635.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local spos=0
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	if spos~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end