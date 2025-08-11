--法老王的归来(ZCG)
function c77239094.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER)	
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)	
    e2:SetCountLimit(1)
    e2:SetCondition(c77239094.condition)
    e2:SetOperation(c77239094.operation)
    c:RegisterEffect(e2)	
end
function c77239094.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0   
end
function c77239094.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_MONSTER)
    local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    Duel.ConfirmCards(tp,hg)
    if g:GetCount()>0 then
        local atk=g:GetSum(Card.GetAttack)
        Duel.Recover(tp,atk,REASON_EFFECT)		
    end
    Duel.ShuffleHand(1-tp)
end