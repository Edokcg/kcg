--混沌黑魔導少女(ZCG)
function c77239979.initial_effect(c)
    c:EnableReviveLimit()
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c77239979.condition)
    e1:SetTarget(c77239979.target)
    e1:SetOperation(c77239979.activate)
    c:RegisterEffect(e1)
	
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77239979.condition1)
    e3:SetTarget(c77239979.target1)
    e3:SetOperation(c77239979.operation1)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------------------------------
function c77239979.condition(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c77239979.filter(c)
    return c:IsAbleToHand()
end
function c77239979.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239979.filter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c77239979.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239979.filter1,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1500)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239979.filter,tp,LOCATION_GRAVE,0,2,2,nil)
    if g:GetCount()>1 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end

end
function c77239979.filter1(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
------------------------------------------------------------------
function c77239979.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c77239979.filter5(c,e,tp)
    return c:IsCode(77239960) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77239979.filter6(c,e,tp)
    return c:IsCode(40737112) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77239979.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77239979.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c77239979.filter6,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239979.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239979.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c77239979.filter6,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)   
    g:Merge(g1)
    if g:GetCount()>1 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end


