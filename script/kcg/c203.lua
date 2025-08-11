--Counterbalance
function c203.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--discard opp deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(511000121,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c203.target)
	e2:SetOperation(c203.activate)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
end

function c203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED,1,nil,TYPE_MONSTER) end
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,dam,0,0) 
end
function c203.activate(e,tp,eg,ep,ev,re,r,rp)
	  local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED,nil,TYPE_MONSTER)
	  local g1=Duel.GetDecktopGroup(tp,dam)
	  local g2=Duel.GetDecktopGroup(1-tp,dam)
	  if g1:GetCount()>0 then
	  local tc1=g1:GetFirst()
	  while tc1 do
	  if not tc1:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) then Duel.DiscardDeck(tp,1,REASON_EFFECT) end
	  tc1=g1:GetNext() end end
	  if g2:GetCount()>0 then
	  local tc2=g2:GetFirst()
	  while tc2 do
	  if not tc2:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) then Duel.DiscardDeck(1-tp,1,REASON_EFFECT) end
	  tc2=g2:GetNext() end end
end
