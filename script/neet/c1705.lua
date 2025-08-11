--毛绒动物·狐貍（neet）
local s,id=GetID()
function s.initial_effect(c)
	--
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)	
end
s.listed_series={SET_FRIGHTFUR,SET_FLUFFAL,SET_EDGE_IMP}
s.listed_names={70245411,CARD_POLYMERIZATION}
function s.cost(e,tp,eg,ev,ep,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.filter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.cfilter(c,setcard,typ)
	return c:IsFaceup() and c:IsSetCard(setcard) and c:IsType(typ)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tg and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
		if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,SET_FLUFFAL,TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,SET_EDGE_IMP,TYPE_MONSTER) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
		if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,SET_FRIGHTFUR,TYPE_MONSTER|TYPE_FUSION) then
			local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if #dg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				Duel.HintSelection(sg,true)
				Duel.BreakEffect()
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
		if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,70245411),tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end