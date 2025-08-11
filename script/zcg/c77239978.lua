--混沌黑魔术的第二仪式
function c77239978.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239978.target)
    e1:SetOperation(c77239978.activate)
    c:RegisterEffect(e1)
end
function c77239978.filter(c,e,tp,m)
    if bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    if c.mat_filter then
        m=m:Filter(c.mat_filter,nil)
    end
    return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c) and c:IsCode(77239979)
end
function c77239978.matfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(77239979)
end
function c77239978.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
        local mg=Duel.GetMatchingGroup(c77239978.matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
        return Duel.IsExistingMatchingCard(c77239978.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239978.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local mg=Duel.GetMatchingGroup(c77239978.matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c77239978.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
    if tg:GetCount()>0 then
        local tc=tg:GetFirst()
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,nil)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
        tc:SetMaterial(mat)
        Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
