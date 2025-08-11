--装甲 空间基地 （ZCG）
function c77240287.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240287,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77240287.cost)
	e2:SetTarget(c77240287.retg)
	e2:SetOperation(c77240287.operation)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
end
function c77240287.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,sg,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ct)
	local g2=Duel.GetOperatedGroup()
	local tc=g2:GetFirst()
	while tc and tc:IsLocation(LOCATION_REMOVED) do 
	tc:RegisterFlagEffect(77240287,RESET_EVENT+RESETS_STANDARD,0,1)
	tc=g2:GetNext()
end
end
function c77240287.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)>0 end
end
function c77240287.operation(e,tp,eg,ep,ev,re,r,rp)
   local ct=e:GetLabel()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ct,ct,nil)
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end










