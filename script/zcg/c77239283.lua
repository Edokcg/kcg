--奥利哈刚 徘徊之魂
function c77239283.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239283,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239283.sptg)
    e2:SetOperation(c77239283.spop)
    c:RegisterEffect(e2)	
end
--------------------------------------------------------------------
function c77239283.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239283.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c77239283.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239283.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil,e,tp)
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_LEAVE_FIELD)
        e2:SetOperation(c77239283.op)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
    end
end
function c77239283.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Recover(c:GetPreviousControler(),c:GetAttack()/2,REASON_EFFECT)
end
