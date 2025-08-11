--晶体青眼白龙(ZCG)
function c77239132.initial_effect(c)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c77239132.setg)
    e3:SetOperation(c77239132.seop)
    c:RegisterEffect(e3)
end
function c77239132.thfilter(c)
    return c:IsAbleToHand()
end
function c77239132.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and  chkc:IsDestructable() and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,0,1,e:GetHandler())
        and Duel.IsExistingMatchingCard(c77239132.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77239132.seop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c77239132.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
