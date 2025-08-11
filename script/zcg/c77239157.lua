--恶魔戒律(ZCG)
function c77239157.initial_effect(c)
    --active
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1) 

    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c77239157.target)
    e2:SetOperation(c77239157.activate)
    c:RegisterEffect(e2)
end
function c77239157.filter(c)
    return c:IsAbleToGrave()
end
function c77239157.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239157.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77239157.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239157.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) then      
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetCode(EFFECT_SKIP_BP)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        Duel.RegisterEffect(e1,tp)
    end
end
