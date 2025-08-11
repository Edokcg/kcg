--奥利哈刚 黑蛇蜕化(ZCG)
function c77239284.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c77239284.condition)
    e1:SetTarget(c77239284.target)
    e1:SetOperation(c77239284.operation)
    c:RegisterEffect(e1)
end
function c77239284.filter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY+REASON_BATTLE) and c:IsSetCard(0xa50)
end
function c77239284.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239284.filter,1,nil,tp)
end
function c77239284.spfilter(c,e,tp)
    return c:IsCode(77239295) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239284.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239284.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77239284.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239284.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()~=0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end

