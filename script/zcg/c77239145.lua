--控龙神官·塞特(ZCG)
function c77239145.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239145,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c77239145.sptg)
	e2:SetOperation(c77239145.spop)
	c:RegisterEffect(e2)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239145,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c77239145.atcon)
	e3:SetCost(c77239145.atcost)
	e3:SetOperation(c77239145.atop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77239145.op)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239145,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c77239145.sptg1)
	e5:SetOperation(c77239145.spop1)
	c:RegisterEffect(e5)
end
function c77239145.sfilter1(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239145.sfilter2(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239145.sfilter3(c,e,tp)
	return c:IsRace(RACE_SEASERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--[[function c77239145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239145.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239145.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239145.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239145.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77239145.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c77239145.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c77239145.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end]]

function c77239145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239145.sfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c77239145.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77239145.sfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c77239145.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c77239145.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,1,nil,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
    local tc=g1:GetFirst()	
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEUP)
	    tc:CompleteProcedure()	
	end
end

function c77239145.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		--and e:GetHandler():IsChainAttackable(0)
end
function c77239145.costfilter(c)
	return c:IsDiscardable()
end
function c77239145.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239145.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c77239145.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c77239145.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c77239145.filter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_DINOSAUR) or c:IsRace(RACE_SEASERPENT)) and c:IsFaceup()
end
function c77239145.op(e,c)
	return Duel.GetMatchingGroupCount(c77239145.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000
end
function c77239145.sfilter(c,e,tp)
	return c:IsCode(77239144) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239145.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239145.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c77239145.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g4=Duel.SelectMatchingCard(tp,c77239145.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g4:GetFirst()	
	if g4:GetCount()>0 then
		Duel.SpecialSummon(g4,0,tp,tp,true,true,POS_FACEUP)
	    tc:CompleteProcedure()	
	end
end
