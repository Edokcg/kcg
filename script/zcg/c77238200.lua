--法老王 亚图姆
function c77238200.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238200,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77238200.target)
    e1:SetOperation(c77238200.operation)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238200,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77238200.spcost)
    e2:SetTarget(c77238200.sptg)
    e2:SetOperation(c77238200.spop)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------------------------------
function c77238200.filter(c)
    return c:IsSetCard(0x201) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77238200.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238200.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77238200.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77238200.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
----------------------------------------------------------------------------------------
function c77238200.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttack()>500 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(-500)
    e:GetHandler():RegisterEffect(e1)
end
function c77238200.filter1(c,e,tp)
    return c:IsSetCard(0xa200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77238200.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77238200.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c77238200.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77238200.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77238200.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end