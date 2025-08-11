--无名-海聶之心
function c77239498.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239498.sptg)
    e1:SetOperation(c77239498.spop)
    c:RegisterEffect(e1)

    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c77239498.condition)	
    e2:SetTarget(c77239498.target)
    e2:SetOperation(c77239498.activate)
    c:RegisterEffect(e2)	
end
------------------------------------------------------------------
function c77239498.filter1(c,e,tp)
    return c:IsCode(77238990) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239498.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239498.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239498.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239498.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
    Duel.Damage(1-tp,e:GetHandler():GetAttack()/2,REASON_EFFECT)
end
------------------------------------------------------------------
function c77239498.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239498.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77239498.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c77239498.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local g1=Duel.GetMatchingGroup(c77239498.filter2,tp,LOCATION_MZONE,0,nil)	
    local tc=g:GetFirst()
    local tc1=g1:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-tc1:GetAttack()/2)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c77239498.filter2(c)
    return c:IsFaceup() and c:IsCode(77238990)
end