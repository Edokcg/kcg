--天位贤者(neet)
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(function(e) return e:GetHandler():GetSummonType()&SUMMON_TYPE_SPECIAL==0 end)
	e9:SetCost(s.spcost)
	e9:SetTarget(s.sptg)
	e9:SetOperation(s.spop)
	c:RegisterEffect(e9)	
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsReleasable() end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon,1,tp,HINTMSG_TARGET)
	if #sg~=3 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
	local sc=sg:RandomSelect(1-tp,1,1,nil):GetFirst()
	if sc then
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		--if sc:IsType(TYPE_EFFECT) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
		--end
	end
	Duel.SpecialSummonComplete()
	sg:RemoveCard(sc)
	local mg=sg:Filter(Card.IsType,nil,TYPE_NORMAL)
	if #mg>0 then Duel.SendtoHand(mg,nil,REASON_EFFECT) end
	sg:Sub(mg)
	if #sg>0 then Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
end