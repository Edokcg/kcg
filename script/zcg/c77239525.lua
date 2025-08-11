--
function c77239525.initial_effect(c)
    --send to grave
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239525.target)
    e1:SetOperation(c77239525.operation)
    c:RegisterEffect(e1)
end
---------------------------------------------------------
function c77239525.filter(c,atk)
    return c:IsAbleToGrave()
end
function c77239525.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE)  end
    if chk==0 then return c:GetAttack()>=500 and Duel.IsExistingTarget(c77239525.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c77239525.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c77239525.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-500)
        c:RegisterEffect(e1)		
    end
end
