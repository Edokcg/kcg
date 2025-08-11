--团结之力(ZCG)
function c77239545.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239545.spcon)	
    e1:SetTarget(c77239545.target)
    e1:SetOperation(c77239545.activate)
    c:RegisterEffect(e1)
end
--[[function c77239545.spcon(e,c)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa80)==0 and Duel.GetLP(tp)<1000
end]]
function c77239545.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.GetLP(tp)<=1000 and Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa80)==0
end
function c77239545.filter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239545.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingMatchingCard(c77239545.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,3,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239545.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239545.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,3,3,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

