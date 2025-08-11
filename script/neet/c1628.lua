--无限的骑士 蒂迈欧
function c1628.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1628,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1628.spcost1)
	e3:SetTarget(c1628.sptg1)
	e3:SetOperation(c1628.spop1)
	c:RegisterEffect(e3)
	--spsummon punk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1628,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1628.spcon2)
	e4:SetCost(c1628.spcost2)
	e4:SetTarget(c1628.sptg2)
	e4:SetOperation(c1628.spop2)
	c:RegisterEffect(e4)
end
function c1628.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c1628.spfilter1(c,e,tp,zone)
	return c:IsSetCard(0xa0) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP,tp,zone)
end
function c1628.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return zone~=0 and Duel.IsExistingMatchingCard(c1628.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c1628.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c1628.spfilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP,zone)
	end
end
function c1628.cfilter(c)
	return c:IsSetCard(0xa0) and (not c:IsOnField() or c:IsFaceup())
end
function c1628.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1628.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct==3
end
function c1628.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1628.spfilter2(c,e,tp,tc)
	return c:IsCode(53315891) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c1628.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1628.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1628.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1628.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end



