--方界波動
function c77239177.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239177.atktg)
    e1:SetOperation(c77239177.atkop)
    c:RegisterEffect(e1)
end
function c77239177.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    e:SetLabelObject(g:GetFirst())
end
function c77239177.atkop(e,tp,eg,ep,ev,re,r,rp)
    local hc=e:GetLabelObject()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()
    if tc==hc then tc=g:GetNext() end
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())		
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(1000)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)		
        if hc:IsFaceup() and hc:IsRelateToEffect(e) then
            Duel.BreakEffect()
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_UPDATE_ATTACK)
            e3:SetValue(-1000)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            hc:RegisterEffect(e3)
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_UPDATE_DEFENSE)
            e4:SetValue(-1000)
            e4:SetReset(RESET_EVENT+0x1fe0000)
            hc:RegisterEffect(e4)			
        end
    end
end

