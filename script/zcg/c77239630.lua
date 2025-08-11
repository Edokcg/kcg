--植物的愤怒 青苔虎
function c77239630.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239630,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239630.con)
    e1:SetTarget(c77239630.target)
    e1:SetOperation(c77239630.operation)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------
function c77239630.con(e,c)
    if c==nil then return true end
    return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil,0xa90)==1
end
function c77239630.filter(c)
    return c:IsCode(77239621) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77239630.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239630.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239630.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239630.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
