--植物的愤怒 魔树苗
function c77239631.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239631,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE) 	
    e1:SetTarget(c77239631.target)
    e1:SetOperation(c77239631.operation)
    c:RegisterEffect(e1)
	
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239631,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE) 	
    e2:SetTarget(c77239631.sptg)
    e2:SetOperation(c77239631.spop)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239631.filter(c)
    return c:IsCode(77239629) and c:IsAbleToHand()
end
function c77239631.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239631.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239631.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239631.filter,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=sg:Select(tp,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end
-----------------------------------------------------------------
function c77239631.filter1(c,e,tp)
    return c:IsCode(77239629) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239631.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239631.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239631.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239631.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end


