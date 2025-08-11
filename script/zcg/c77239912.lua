--王之名 亚图姆(ZCG)
function c77239912.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239912.cost)
    e1:SetTarget(c77239912.target)
    e1:SetOperation(c77239912.operation)
    c:RegisterEffect(e1)
end
---------------------------------------------------------------------------------
function c77239912.cfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToGraveAsCost()
end
function c77239912.cfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToGraveAsCost()
end
function c77239912.cfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToGraveAsCost()
end
function c77239912.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239912.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239912.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239912.cfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c77239912.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c77239912.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c77239912.cfilter3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SendtoGrave(g1,REASON_EFFECT)
end
function c77239912.filter(c,e,tp)
    return (c:IsCode(77239901) or c:IsCode(77239900) or c:IsCode(77239905)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239912.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239912.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77239912.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239912.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()	
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		--[[if tc:GetCode(77239901) then
            tc:CompleteProcedure()
		end]]
    end
end

