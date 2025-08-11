--伯爵上位
function c77239544.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239544.spcon)	
    e1:SetTarget(c77239544.target)
    e1:SetOperation(c77239544.activate)
    c:RegisterEffect(e1)
end
----------------------------------------------------------------
function c77239544.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80)
end
function c77239544.spcon(e,c)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c77239544.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c77239544.filter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239544.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239544.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239544.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239544.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end