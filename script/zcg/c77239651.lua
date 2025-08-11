--植物的愤怒 异变(ZCG)
function c77239651.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239651.condition)	
    e1:SetTarget(c77239651.target)
    e1:SetOperation(c77239651.activate)
    c:RegisterEffect(e1)
end
function c77239651.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c77239651.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c77239651.filter,tp,LOCATION_MZONE,0,1,nil) 
end
function c77239651.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239651.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
    end
end
