--祭品魔盘
function c77239032.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239032.target)
    e1:SetOperation(c77239032.activate)
    c:RegisterEffect(e1)
end
function c77239032.filter(c)
    return not (c:IsHasEffect(EFFECT_UNRELEASABLE_SUM) and c:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM))
end
function c77239032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77239032.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239032.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c77239032.filter,tp,0,LOCATION_MZONE,1,2,nil)
end
function c77239032.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()	
    while tc do
        if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EXTRA_RELEASE)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
		end
        tc=g:GetNext()
    end
end
