--三幻神之光
function c77239910.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239910.cost)
    e1:SetTarget(c77239910.target)
    e1:SetOperation(c77239910.operation)
    c:RegisterEffect(e1)
end
---------------------------------------------------------------------------------
function c77239910.cfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToRemoveAsCost()
end
function c77239910.cfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToRemoveAsCost()
end
function c77239910.cfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToRemoveAsCost()
end
function c77239910.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239910.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239910.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239910.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.CheckLPCost(tp,1000) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c77239910.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c77239910.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectMatchingCard(tp,c77239910.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
	Duel.PayLPCost(tp,1000)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c77239910.filter(c,e,tp)
    return (c:IsCode(77239901) or c:IsCode(77239902) or c:IsCode(77239903) or c:IsCode(77239905)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239910.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239910.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239910.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239910.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
	if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		--[[if tc:GetCode(77239903) then
            tc:CompleteProcedure()
		end]]
    end
end

