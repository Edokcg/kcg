--六芒星 幼龙(ZCG)
function c77239415.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239415.tg)
    e1:SetOperation(c77239415.op)
    c:RegisterEffect(e1)
end
----------------------------------------------------------------------
function c77239415.filter(c)
    return c:GetLevel()==12 and c:IsAbleToHand()
end
function c77239415.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239415.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239415.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239415.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()	
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)		
        e1:SetCode(EFFECT_UNRELEASABLE_SUM)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)		
    end
end
