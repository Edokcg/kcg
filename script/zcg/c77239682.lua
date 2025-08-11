--月蚀(ZCG)
function c77239682.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DRAW)
    e2:SetCondition(c77239682.condition)
    e2:SetOperation(c77239682.operation)
    c:RegisterEffect(e2)
end
function c77239682.filter(c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c77239682.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c77239682.operation(e,tp,eg,ep,ev,re,r,rp)
    if ep==e:GetOwnerPlayer() then return end
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    Duel.ConfirmCards(1-ep,hg)
    local dg=hg:Filter(c77239682.filter,nil)
    Duel.SendtoHand(dg,tp,REASON_EFFECT)	
    Duel.ShuffleHand(ep)
end
