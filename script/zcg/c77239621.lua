--植物的愤怒 古树(ZCG)
function c77239621.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239621,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239621.tg)
    e2:SetOperation(c77239621.op)
    c:RegisterEffect(e2)
	
    --battle destroyed
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239621,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239621.condition)
    e1:SetTarget(c77239621.target)
    e1:SetOperation(c77239621.operation)
    c:RegisterEffect(e1)	
end
--------------------------------------------------------------------------------------
function c77239621.filter(c)
    return c:IsLevelBelow(2) and c:IsAbleToHand()
end
function c77239621.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239621.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239621.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239621.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ShuffleDeck(tp)
    end
end
---------------------------------------------------------------------------------------
function c77239621.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
        and bit.band(e:GetHandler():GetReason(),REASON_BATTLE)~=0
end
function c77239621.filter1(c,e,tp)
    return c:IsCode(77239621) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
--[[function c77239621.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239621.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239621.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(c77239621.filter1,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239621,1)) then
        Duel.BreakEffect()
        Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
        if ft>1 and g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(77239621,1)) then
            Duel.SpecialSummonStep(g:GetNext(),0,tp,tp,false,false,POS_FACEUP)
        end
        Duel.SpecialSummonComplete()
    end
end]]
function c77239621.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239621.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239621.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239621.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()   
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end