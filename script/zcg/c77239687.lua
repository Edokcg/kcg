--神圣召唤(ZCG)
function c77239687.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --trigger
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c77239687.check)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetDescription(aux.Stringid(77239687,0))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_CUSTOM+77239687)
    e3:SetTarget(c77239687.target)
    e3:SetOperation(c77239687.operation)
    c:RegisterEffect(e3)
end

function c77239687.check(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    while tc do
        if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsReason(REASON_DESTROY) and tc:GetPreviousControler()==tp
            and tc:IsRace(RACE_SPELLCASTER) and tc:GetAttack()~=0 and tc:IsPreviousPosition(POS_FACEUP) then
            Duel.RaiseSingleEvent(c,EVENT_CUSTOM+77239687,e,r,rp,tc:GetControler(),tc:GetAttack())
        end
        tc=eg:GetNext()
    end
end
function c77239687.filter(c,atk,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:GetAttack()>atk and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239687.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e)
        and Duel.IsExistingMatchingCard(c77239687.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,ev,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c77239687.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239687.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,ev,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
