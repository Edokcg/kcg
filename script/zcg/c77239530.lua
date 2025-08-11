--女子佣兵 伯爵(ZCG)
function c77239530.initial_effect(c)
   --pos
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239530,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCost(c77239530.cost)	
    e1:SetCondition(c77239530.actcon)
    e1:SetTarget(c77239530.target)
    e1:SetOperation(c77239530.activate)
    c:RegisterEffect(e1)

    --actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,1)
    e2:SetValue(c77239530.aclimit)
    e2:SetCondition(c77239530.actcon)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------------
function c77239530.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239530.costfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80) and c:IsAbleToGraveAsCost()
end
function c77239530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239530.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239530.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c77239530.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239530.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
    end
end
-------------------------------------------------------------------
function c77239530.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end



