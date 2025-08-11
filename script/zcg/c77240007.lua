--神之领域(ZCG)
function c77240007.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77240007.cost)
    e1:SetTarget(c77240007.target)
    e1:SetOperation(c77240007.operation)
    c:RegisterEffect(e1)
end
---------------------------------------------------------------------------------
function c77240007.cfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToRemoveAsCost()
end
function c77240007.cfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToRemoveAsCost()
end
function c77240007.cfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToRemoveAsCost()
end
function c77240007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240007.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77240007.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77240007.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c77240007.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c77240007.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectMatchingCard(tp,c77240007.cfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c77240007.filter(c,e,tp)
    return c:IsCode(77239922) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77240007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77240007.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240007.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,77240007)~=0 then return end
    Duel.RegisterFlagEffect(tp,77240007,0,0,0)
    c:SetTurnCounter(0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetOperation(c77240007.checkop)
    e1:SetCountLimit(1)
    Duel.RegisterEffect(e1,tp)
    c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,3)
    c77240007[c]=e1
end
function c77240007.checkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==3 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240007.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    elseif ct==10 then
        Duel.Win(tp,0x30)
    end
end