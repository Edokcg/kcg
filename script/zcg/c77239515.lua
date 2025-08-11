--女子佣兵 狐妖(ZCG)
function c77239515.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa80))
	e1:SetCondition(c77239515.condition)
    e1:SetValue(1000)
    c:RegisterEffect(e1)
	
    --检索
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239515,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetTarget(c77239515.target)
    e2:SetOperation(c77239515.operation)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------
function c77239515.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
---------------------------------------------------------------------
function c77239515.filter(c)
    return c:IsCode(77239515) and c:IsAbleToHand()
end
function c77239515.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239515.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239515.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
