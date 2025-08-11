--矿山爆破(ZCG)
function c77239163.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c77239163.target)
    e1:SetOperation(c77239163.activate)
    c:RegisterEffect(e1)
end
function c77239163.filter(c)
    return c:IsAbleToGrave()
end
function c77239163.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239163.filter,tp,LOCATION_DECK,0,5,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_DECK)
end
function c77239163.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239163.filter,tp,LOCATION_DECK,0,5,5,nil)
    if g:GetCount()>4 then
        Duel.SendtoGrave(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
