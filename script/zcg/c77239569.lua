--王者的决断(ZCG)
function c77239569.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239569.target)
    e1:SetOperation(c77239569.activate)
    c:RegisterEffect(e1)
end
function c77239569.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239569.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
    local tc1=g:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmCards(tp,tc1)
    if op==0 and tc1:GetType()==TYPE_MONSTER then
            if tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
        Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
		end   
    elseif op==1 and tc1:GetType()==TYPE_SPELL then
            if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
        Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
    end
    elseif op==2 and tc1:GetType()==TYPE_TRAP then
           if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
        Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
    end
    end
    Duel.ShuffleHand(1-tp)	
end
