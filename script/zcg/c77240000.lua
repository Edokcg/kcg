--宿命の白竜女
function c77240000.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240000,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c77240000.cost)
	e3:SetTarget(c77240000.sptg)
	e3:SetOperation(c77240000.spop)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetCondition(c77240000.atkcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
end
function c77240000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c77240000.sfilter(c,e,tp)
	return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240000.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240000.filter1(c)
	return c:IsCode(77239146) and c:IsAbleToHand()
end
function c77240000.filter2(c)
	return c:IsCode(77239121) and c:IsAbleToHand()
end
function c77240000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240000.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.GetMatchingGroup(c77240000.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,e,tp,ev)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.GetMatchingGroup(c77240000.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,e,tp,ev)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77240000,1)) then
			Duel.BreakEffect()
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end
function c77240000.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,89631139)
end
