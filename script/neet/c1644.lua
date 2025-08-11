--异怪之妖精 艾尔芙妮
function c1644.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),3,2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1644,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1644)
	e1:SetCondition(c1644.rmcon)
	e1:SetTarget(c1644.rmtg)
	e1:SetOperation(c1644.rmop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1644,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1644+100)
	e2:SetCost(c1644.thcost)
	e2:SetTarget(c1644.thtg)
	e2:SetOperation(c1644.thop)
	c:RegisterEffect(e2)
end
function c1644.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c1644.rmfilter(c)
	return c:IsAbleToRemove() and c:IsPosition(POS_FACEDOWN)
end
function c1644.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1644.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c1644.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1644.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c1644.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1644.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand() and c:IsLevelAbove(1)
end
function c1644.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1644.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1644.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c1644.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local res=false
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetLabel(tc:GetLevel()+1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetValue(c1644.val)
		Duel.RegisterEffect(e1,tp)
		res=true
	end
	if res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsLevel(3) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(1644,2)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1644.val(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLevelAbove(e:GetLabel())
end