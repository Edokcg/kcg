--神之毁灭
function c77240102.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77240102.condition)
    e1:SetTarget(c77240102.target)
    e1:SetOperation(c77240102.activate)
    c:RegisterEffect(e1)
end
function c77240102.cfilter(c)
    return c:IsFaceup() and(c:IsCode(10000000) or c:IsSetCard(0xa220))
end
function c77240102.cfilter1(c)
    return c:IsFaceup() and(c:IsCode(10000010) or c:IsSetCard(0xa210))
end
function c77240102.cfilter2(c)
    return c:IsFaceup() and(c:IsCode(10000020) or c:IsSetCard(0xa100))
end
function c77240102.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77240102.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(c77240102.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) and 
	Duel.IsExistingMatchingCard(c77240102.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77240102.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240102.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
