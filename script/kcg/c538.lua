--機皇創世
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_MEKLORD,SET_MEKLORD_EMPEROR,SET_MEKLORD_ASTRO}

function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(SET_MEKLORD_ASTRO)
end
function s.costfilter(c)
	return c:ListsArchetype(SET_MEKLORD) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true) and c:IsMonster()
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg)
end
function s.costfilter2(c)
	return c:ListsArchetype(SET_MEKLORD) and c:IsAbleToGraveAsCost() and c:IsMonster()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_HAND,0,nil)
	local a=Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #g>2 
		and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0)
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g2>2
	if chk==0 then return a or b end
	if a and b then 
		local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,1))
		if opt==0 then a=true b=false end
		if opt==1 then a=false b=true end
	end
	if a then
	    local sg=aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,1,tp,HINTMSG_REMOVE)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local sg=Duel.SelectMatchingCard(tp,s.costfilter2,tp,LOCATION_HAND,0,3,3,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT,tp)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(s.filter,tp,0x13,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,0x13,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.thfilter(c)
	return c:IsSpellTrap() and c:ListsArchetype(SET_MEKLORD,SET_MEKLORD_EMPEROR) and c:IsAbleToGrave()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,3,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end