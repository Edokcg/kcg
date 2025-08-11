--法老王的觉醒(ZCG)
function c77239913.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)	
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239913.cost)
    e1:SetTarget(c77239913.target)
    e1:SetOperation(c77239913.operation)
    c:RegisterEffect(e1)
end
function c77239913.cfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToGraveAsCost()
end
function c77239913.cfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToGraveAsCost()
end
function c77239913.cfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToGraveAsCost()
end
function c77239913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239913.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239913.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239913.cfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c77239913.cfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c77239913.cfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c77239913.cfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c77239913.filter(c,e,tp)
    return c:IsCode(77239902) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239913.filter1(c,e,tp)
    return c:IsCode(77239920) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239913.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77239913.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) 
        and Duel.IsExistingMatchingCard(c77239913.filter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239913.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239913.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c77239913.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc1=g1:GetFirst()
    if tc1 then
        Duel.SpecialSummon(tc1,0,tp,tp,true,true,POS_FACEUP)
        tc1:CompleteProcedure()
    end	
end

