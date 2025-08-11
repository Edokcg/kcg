--幻魔之卡通援助
function c77240055.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77240055.condition)	
    e1:SetTarget(c77240055.target)
    e1:SetOperation(c77240055.activate)
    c:RegisterEffect(e1)
end
function c77240055.cfilter(c)
    return c:IsFaceup() and (c:IsCode(77240073) or c:IsCode(77240074) or c:IsCode(77240075))
end
function c77240055.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77240055.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77240055.filter(c,e,tp)
    return c:IsSetCard(0x62) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240055.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77240055.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240055.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240055.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,e,tp)
    if g:GetCount()>1 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
