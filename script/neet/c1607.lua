--灵魂鸟神-伊孔雀(neet)
local m=1607
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local sme,soe=Spirit.AddProcedure(c,EVENT_SPSUMMON_SUCCESS)
	--Mandatory return
	sme:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	sme:SetTarget(cm.mrettg)
	sme:SetOperation(cm.retop)
	--Optional return
	soe:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	soe:SetTarget(cm.orettg)
	soe:SetOperation(cm.retop)
	--must ritual
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tdcon)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	cm.shinobird_effect=e1  
end
cm.listed_names={TOKEN_SHINOBIRD,1289}
cm.listed_card_types={TYPE_SPIRIT}
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.filter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and not c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0
		or not Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then return end
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #sg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	if #ssg>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(ssg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.mrettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Spirit.MandatoryReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function cm.tkcheck(e,tp)
	return Duel.GetMZoneCount(tp,e:GetHandler())>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_SHINOBIRD,0,TYPES_TOKEN,1500,1500,4,RACE_WINGEDBEAST,ATTRIBUTE_WIND)
end
function cm.orettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,0) and cm.tkcheck(e,tp) end
	Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_HAND) and cm.tkcheck(e,tp) then
		for _=1,2 do
			local token=Duel.CreateToken(tp,TOKEN_SHINOBIRD)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end