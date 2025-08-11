--植物的愤怒 沙虫
function c77239635.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239635.spcon)
    c:RegisterEffect(e1)

    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239635,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)	
    e3:SetCountLimit(1)
    e3:SetTarget(c77239635.tg)
    e3:SetOperation(c77239635.op)
    c:RegisterEffect(e3)
    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239635,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239635.cost)
    e2:SetTarget(c77239635.target)
    e2:SetOperation(c77239635.operation)
    c:RegisterEffect(e2)
end
--------------------------------------------------------------------
function c77239635.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa90)
end
function c77239635.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239635.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--------------------------------------------------------------------
function c77239635.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239635.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(0)
        tc:RegisterEffect(e2)
    end
end
--------------------------------------------------------------------
function c77239635.filter(c)
    return c:IsCode(77239644) and c:IsAbleToHand()
end
function c77239635.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239635.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239635.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239635.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239635.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


