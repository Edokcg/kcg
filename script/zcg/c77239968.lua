--黑魔導女孩 小辣妹(ZCG)
function c77239968.initial_effect(c)
    --flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239968,0))
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77239968.target)
    e1:SetOperation(c77239968.operation)
    c:RegisterEffect(e1)
end
function c77239968.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
end
function c77239968.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
    local tc=sg:GetFirst()
    while tc do
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            Duel.GetControl(tc,tp,PHASE_END,1)                   
        end
        tc=sg:GetNext()
    end
end
