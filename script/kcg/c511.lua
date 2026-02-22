--カオス・ブルーム
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SET+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
s.listed_series={SET_MEKLORD_EMPEROR,SET_MEKLORD,SET_MEKLORD_ASTRO}

function s.filter1(c)
	return c:IsFaceup() and c:IsAttackBelow(1000) and c:IsDestructable()
end
function s.filter2(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	local a= ct>=0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b= ct>=1 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	local c= ct>=2 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	if chk==0 then return a or b or c end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	local a= ct>=0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b= ct>=1 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	local c= ct>=2 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	if ct==0 and a then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if ct==1 then
		local chk=false
		if a then
			if not b or Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if b and (not chk or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if ct>=2 then
		local chk=false
		if a then
			if (not b and not c) or Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,0,1,1,nil)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if b then
			if (not chk and not c) or Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if c and (not chk or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)-1
	local a= ct>=0 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
	local b= ct>=1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler())
	local c= ct>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter3),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and (a or b or c) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.thfilter1(c)
	return c:IsMonster() and c:ListsArchetype(SET_MEKLORD_EMPEROR,SET_MEKLORD) and c:IsAbleToGrave()
end
function s.thfilter2(c)
	return c:IsSpellTrap() and c:ListsArchetype(SET_MEKLORD_EMPEROR,SET_MEKLORD) and c:IsSSetable()
end
function s.thfilter3(c,e,tp)
	return c:IsMonster() and c:IsSetCard(SET_MEKLORD_ASTRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	local a= ct>=0 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b= ct>=1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler())
	local c= ct>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter3),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
	if chk==0 then return a or b or c end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SET,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,id)
	local a= ct>=0 and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b= ct>=1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler())
	local c= ct>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter3),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
	if ct==0 and a then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT,tp)
	end
	if ct==1 then
		local chk=false
		if a then
			if not b or Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT,tp)
			end
		end
		if b and (not chk or Duel.SelectYesNo(tp,aux.Stringid(id,4))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,e:GetHandler())
			Duel.SSet(tp,g)
		end
	end
	if ct>=2 then
		local chk=false
		if a then
			if (not b and not c) or Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT,tp)
			end
		end
		if b then
			if (not chk and not c) or Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				chk=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,e:GetHandler())
				Duel.SSet(tp,g)
			end
		end
		if c and (not chk or Duel.SelectYesNo(tp,aux.Stringid(id,5))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter3),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end