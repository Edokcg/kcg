--奥利哈刚之神怒(ZCG)
function c77239254.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)	
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetType(EFFECT_TYPE_IGNITION)	
    e2:SetRange(LOCATION_SZONE)	
    e2:SetCountLimit(1)	
    e2:SetCost(c77239254.cost)	
    e2:SetCondition(c77239254.condition)
    e2:SetOperation(c77239254.operation)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------
function c77239254.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c77239254.cfilter(c)
    return c:IsFaceup() and c:IsCode(77239230)
end
function c77239254.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1
end
function c77239254.operation(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    --if g2==0 or g2%2~=0 then Duel.Destroy(e:GetHandler(),REASON_RULE) return end 
    local gc=Duel.GetMatchingGroup(c77239254.costfilter,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
    Duel.SendtoGrave(gc,REASON_COST)
end