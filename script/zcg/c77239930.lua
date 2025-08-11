--邪神降临
function c77239930.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE) 
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239930.cost)
    --e1:SetTarget(c77239930.target)
    e1:SetOperation(c77239930.spop1)
    c:RegisterEffect(e1)
end
-------------------------------------------------------------------------------------
function c77239930.cfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToRemoveAsCost()
end
function c77239930.cfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToRemoveAsCost()
end
function c77239930.cfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToRemoveAsCost()
end
function c77239930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239930.cfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239930.cfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239930.cfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
        and Duel.CheckLPCost(tp,1000) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c77239930.cfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c77239930.cfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c77239930.cfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
	Duel.PayLPCost(tp,1000)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
--[[function c77239930.spfilter(c,e,tp,code)
    return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239930.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingMatchingCard(c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp,77239931)
        and Duel.IsExistingMatchingCard(c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp,77239932)
        and Duel.IsExistingMatchingCard(c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp,77239933) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp,77239931)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp,77239932)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g3=Duel.SelectTarget(tp,c77239930.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp,77239933)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c77239930.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
        end
	end
end]]

function c77239930.sfilter1(c,e,tp)
	return c:IsCode(77239931) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239930.sfilter2(c,e,tp)
	return c:IsCode(77239932) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239930.sfilter3(c,e,tp)
	return c:IsCode(77239933) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77239930.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g1=Duel.SelectMatchingCard(tp,c77239930.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g2=Duel.SelectMatchingCard(tp,c77239930.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g3=Duel.SelectMatchingCard(tp,c77239930.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   g1:Merge(g2)
   g1:Merge(g3)
   if g1:GetCount()>0 then
       Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEUP)
   end
end