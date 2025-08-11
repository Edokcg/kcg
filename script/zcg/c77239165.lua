--魔神冲击(ZCG)
function c77239165.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239165.target)
    e1:SetOperation(c77239165.activate)
    c:RegisterEffect(e1)
end
function c77239165.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239165.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77239165.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239165.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    local sg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)	
    Duel.Destroy(sg1,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(c77239165.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if g:GetCount()>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,2,2,nil)
        local tc=sg:GetFirst()
        Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
        tc=sg:GetNext()
        Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
        Duel.SpecialSummonComplete()     
    end	
end