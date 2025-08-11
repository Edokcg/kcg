--神石板 神力拥有者(ZCG)
function c77239115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c77239115.cost)	
	e1:SetTarget(c77239115.target)
	e1:SetOperation(c77239115.activate)
	c:RegisterEffect(e1)
end
function c77239115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,100) end
    Duel.PayLPCost(tp,100)
end
function c77239115.filter(c,e,tp)
	return c:IsCode(77239116) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c77239115.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239115.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239115.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,nil,e,tp)
	if g:GetCount()>1 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

