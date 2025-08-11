--上古武器箱(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		 --cannot be destroyed
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetValue(s.efilter2)
	c:RegisterEffect(e11)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.efilter2(e,re)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsSetCard(0xa120)
end
function s.filter(c)
	return c:IsSetCard(0xa120) and  c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,5,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local hgg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if #hgg>0 then
		local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,3,3,nil)
		Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end




