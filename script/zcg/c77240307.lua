--冥界的通行令牌(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg2=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	if chk==0 then return sg>0 and sg2>0 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,sg,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ct)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if chk==0 then return sg>0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
   local ct=e:GetLabel()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
   local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,ct,ct,nil)
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

