--电子反应
function c77240048.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77240048.target)
    e1:SetOperation(c77240048.activate)
    c:RegisterEffect(e1)
end
function c77240048.filter(c,e,tp)
    return c:IsCode(70095154) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240048.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingMatchingCard(c77240048.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77240048.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240048.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil,e,tp)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1,true)
            Duel.SpecialSummonComplete()
            tc=g:GetNext()
        end
    end
end
