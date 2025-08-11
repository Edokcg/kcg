--女子佣兵 魔法仆人
function c77239531.initial_effect(c)

    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77239531.drcon)
    e3:SetTarget(c77239531.target)
    e3:SetOperation(c77239531.activate)
    c:RegisterEffect(e3)  	
end
----------------------------------------------------------------
function c77239531.drcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_DESTROY)~=0
end
function c77239531.filter(c,e,tp)
    return c:IsCode(77239511) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239531.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239531.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239531.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239531.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
---------------------------------------------------------------



