--连击小龙 齿车戒龙(neet Rush)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)		
end
function s.filter(c,e,tp)
	return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function s.spfilter(c,e,tp)
	if not c:IsRace(RACE_DRAGON) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	return not c:IsCode(160302001) or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,1,nil) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsAbleToGraveAsCost() end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Requirement
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	g:AddCard(c)
	if Duel.SendtoGrave(g,REASON_COST)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		if tc:IsOnField() and tc:IsCode(160302001) and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local sc=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,1,1,nil,e,tp):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-600)
			sc:RegisterEffect(e1)
		end
	end
end