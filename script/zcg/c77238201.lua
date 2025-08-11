--爱西斯神官
function c77238201.initial_effect(c)
    --todeck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238201,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77238201.target)
    e1:SetOperation(c77238201.operation)
    c:RegisterEffect(e1)
	
    --act limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c77238201.aclimit)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------------
function c77238201.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,5,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c77238201.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,5,5,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
----------------------------------------------------------------------
function c77238201.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
