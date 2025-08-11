--六芒龙神骑术 （ZCG）
function c77240234.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77240234.cost)
	e1:SetCondition(c77240234.condition)
	e1:SetTarget(c77240234.target)
	e1:SetOperation(c77240234.activate)
	c:RegisterEffect(e1)
end
function c77240234.cfilter(c)
	return c:IsCode(77239401) or c:IsCode(77240238) or c:IsCode(77239405) or c:IsCode(77239402) or c:IsCode(77239406) or c:IsCode(77239404) or c:IsCode(77239403)
end
function c77240234.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77240234.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function c77240234.hfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c77240234.hgfilter(c)
	return not (c:IsCode(77239401) or c:IsCode(77240238) or c:IsCode(77239405) or c:IsCode(77239402) or c:IsCode(77239406) or c:IsCode(77239404) or c:IsCode(77239403))
end
function c77240234.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(c77240234.hgfilter,tp,LOCATION_HAND,0,nil)
	hg:RemoveCard(e:GetHandler())
	if chk==0 then return hg:GetCount()>0 and hg:FilterCount(c77240234.hfilter,nil)==hg:GetCount() end
	Duel.SendtoGrave(hg,REASON_COST)
end
function c77240234.filter(c)
	return c:IsCode(77239420) and c:IsAbleToHand()
end
function c77240234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240234.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77240234.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77240234.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
