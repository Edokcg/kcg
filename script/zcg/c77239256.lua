--奥利哈刚地狱之战
function c77239256.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239256.con)
    e1:SetTarget(c77239256.target)
    e1:SetOperation(c77239256.activate)
    c:RegisterEffect(e1)
end
function c77239256.con(e)
    return Duel.GetMatchingGroupCount(c77239256.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)>=3
end
function c77239256.filter(c)
    return c:IsSetCard(0xa50) and c:IsType(TYPE_MONSTER)and c:IsAbleToRemove()
end
function c77239256.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c77239256.filter,tp,LOCATION_GRAVE,0,1,nil)
    and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c77239256.activate(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c77239256.filter,tp,LOCATION_GRAVE,0,1,ct,nil)
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
        local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ct,ct,nil)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end