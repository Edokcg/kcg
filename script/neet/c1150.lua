--暮光道剑士 罗兰德(neet)
local s,id=GetID()
function s.initial_effect(c)
	-- Send to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.discon2)
	e3:SetTarget(s.distg2)
	e3:SetOperation(s.disop2)
	c:RegisterEffect(e3)
end
s.listed_series={0x38}
function s.rmfilter(c)
	return c:IsSetCard(0x38) and c:IsAbleToRemoveAsCost()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsCode(10071151,56166150,83550869,84673417,1150) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tgfilter(c,e,tp,ck)
	return c:IsSetCard(0x38) and (c:IsAbleToHand() or (ck and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ck=e:GetLabel()==1
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ck)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ck=e:GetLabel()==1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ck):GetFirst()
	if tc then
		if ck and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil,0x38)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,g)
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil,0x38)
	Duel.DiscardDeck(tp,g,REASON_EFFECT)
end