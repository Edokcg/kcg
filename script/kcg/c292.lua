--Legend of Heart
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35699,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={SET_LEGENDARY_DRAGON}
s.listed_names={293,294,295}

function s.cost2filter(c,tp)
	return c:IsRace(RACE_WARRIOR) and Duel.GetMZoneCount(tp,c)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.CheckReleaseGroup(tp,s.cost2filter,1,nil,tp)
	end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
	Duel.Release(rg,REASON_COST)
end
function s.costfilter(c,e,tp)
	return c:IsSetCard(SET_LEGENDARY_DRAGON) and c:IsSpell() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local rmg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.costfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if #rmg==0 then return end
	local rmct=rmg:GetClassCount(Card.GetCode)
	local ct=math.min(3,ft,rmct)
	if ct==0 then return end
	local g=aux.SelectUnselectGroup(rmg,e,tp,1,ct,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
	end
	Duel.BreakEffect()
	local sg=Duel.GetOperatedGroup()
	for tc in aux.Next(sg) do
		if tc:IsOriginalCode(281) then
			tc:SetEntityCode(293,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		elseif tc:IsOriginalCode(280) then
			tc:SetEntityCode(294,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		elseif tc:IsOriginalCode(282) then
			tc:SetEntityCode(295,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		end
	end
end
