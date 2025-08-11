--光之创造神石板
function c77239920.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239920,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239920.target)
    e1:SetOperation(c77239920.operation)
    c:RegisterEffect(e1)	
end
--------------------------------------------------------------
function c77239920.spfilter1(c,e,tp)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239920.spfilter2(c,e,tp)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239920.spfilter3(c,e,tp)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239920.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingTarget(c77239920.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239920.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239920.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,c77239920.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c77239920.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g3=Duel.SelectTarget(tp,c77239920.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c77239920.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if g:GetCount()~=3 or ft<3 then return end
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    local sg=Duel.GetMatchingGroup(c77239920.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if sg:GetCount()>0 then
        Duel.Destroy(sg,REASON_EFFECT)
    end	
end
function c77239920.filter1(c)
    return c:IsFaceup() and c:IsCode(77238410)
end

