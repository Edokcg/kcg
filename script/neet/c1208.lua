--灵魂鸟神-稚孔雀(neet)
local m=1208
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local sme,soe=Spirit.AddProcedure(c,EVENT_SPSUMMON_SUCCESS)
	--Mandatory return
	sme:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	sme:SetTarget(cm.mrettg)
	sme:SetOperation(cm.retop)
	--Optional return
	soe:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	soe:SetTarget(cm.orettg)
	soe:SetOperation(cm.retop)
	--
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SPIRIT),2,2)
	--must ritual
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.lnklimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tdcon)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	cm.shinobird_effect=e1  
end
cm.listed_names={25415052,52900000,1307,1607}
cm.listed_card_types={TYPE_SPIRIT}
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_GRAVE,1,3,nil)
	if #g==0 or Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0
		or not Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #sg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ssg=sg:Select(tp,1,1,nil)
	if #ssg>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(ssg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ssg)
	end
end
function cm.mrettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Spirit.MandatoryReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(25415052) or c:IsCode(52900000) or c:IsCode(1307) or c:IsCode(1607) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tkcheck(e,tp)
	return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
end
function cm.orettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,0) and cm.tkcheck(e,tp) end
	Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_EXTRA) and cm.tkcheck(e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end