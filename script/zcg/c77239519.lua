--女子佣兵 天使
function c77239519.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239519,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c77239519.spcost)
    e1:SetTarget(c77239519.sptg)
    e1:SetOperation(c77239519.spop)
    c:RegisterEffect(e1)
	
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239519,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetCondition(c77239519.condition)
    e2:SetTarget(c77239519.target)
    e2:SetOperation(c77239519.operation)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239519.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239519.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239519.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239519.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239519.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239519.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
-----------------------------------------------------------------
function c77239519.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c77239519.filter(c)
    return c:IsCode(77239519) and c:IsAbleToHand()
end
function c77239519.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239519.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239519.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239519.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
