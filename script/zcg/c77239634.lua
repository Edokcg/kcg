--植物的愤怒 地罗葡
function c77239634.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239634,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239634.sumtg)
    e2:SetOperation(c77239634.sumop)
    c:RegisterEffect(e2)

    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239634,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239634.cost)
    e3:SetTarget(c77239634.shtg)
    e3:SetOperation(c77239634.shop)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------
function c77239634.filter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0xa90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239634.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239634.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239634.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239634.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
-----------------------------------------------------------------
function c77239634.filter2(c)
    return c:IsCode(77239644) and c:IsAbleToHand()
end
function c77239634.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239634.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239634.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239634.shop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239634.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end




