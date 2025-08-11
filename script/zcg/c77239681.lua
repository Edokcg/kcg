--连击之力(ZCG)
function c77239681.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239681.target)
    e1:SetOperation(c77239681.activate)
    c:RegisterEffect(e1)
end
function c77239681.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c77239681.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(c77239681.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c77239681.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77239681.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EXTRA_ATTACK)
        e2:SetValue(2)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
    end
end
