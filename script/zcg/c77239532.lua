--女子佣兵 初学者
function c77239532.initial_effect(c)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c77239532.spcon)
    e2:SetTarget(c77239532.sptg)
    e2:SetOperation(c77239532.spop)
    c:RegisterEffect(e2)
end
----------------------------------------------------------------
function c77239532.spfilter1(c)
    return c:IsCode(77239532)
end
function c77239532.spcon(e,c)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c77239532.spfilter1,c:GetControler(),LOCATION_GRAVE,0,3,nil)
end
function c77239532.spfilter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239532.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239532.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239532.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local count=0
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft1>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c77239532.spfilter,tp,LOCATION_HAND,0,ft1,ft1,nil,e,tp)
        if g:GetCount()>0 then
            local tc=g:GetFirst()
            while tc do
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                tc=g:GetNext()
                count=count+1
            end
        end
    end
    if count>0 then Duel.SpecialSummonComplete() end
end