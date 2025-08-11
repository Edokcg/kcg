--殉道者之无限替换（ZCG）
function c77240222.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77240222.target)
	e1:SetOperation(c77240222.activate)
	c:RegisterEffect(e1)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240222.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240222.distg9)
	c:RegisterEffect(e12)
end
function c77240222.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240222.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240222.filter(c)
	return c:IsAbleToHand()
end
function c77240222.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240222.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77240222.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77240222.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(c:GetControler())
	 end
	end
end
