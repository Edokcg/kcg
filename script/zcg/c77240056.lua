--回击锤
function c77240056.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(3030892,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCost(c77240056.cost)	
    e1:SetCondition(c77240056.condition)
    e1:SetTarget(c77240056.target)
    e1:SetOperation(c77240056.operation)
    c:RegisterEffect(e1)
end
function c77240056.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c77240056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
    if g:GetCount()>0 then
        Duel.ConfirmCards(tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT)
        Duel.ShuffleHand(1-tp)
    end
end
function c77240056.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77240056.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end