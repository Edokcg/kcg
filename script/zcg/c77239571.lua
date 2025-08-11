--战魂附体(ZCG)
function c77239571.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239571.target)
    e1:SetOperation(c77239571.activate)
    c:RegisterEffect(e1)
end
-------------------------------------------------------------------------
function c77239571.filter(c)
    return c:IsFaceup()
end
function c77239571.filter1(c)
    return c:IsAbleToRemove()
end
function c77239571.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c77239571.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
	and Duel.IsExistingMatchingCard(c77239571.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c77239571.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239571.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    local atk=g:GetFirst():GetAttack()
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g1=Duel.SelectTarget(tp,c77239571.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        tc:RegisterEffect(e1)
    end
end
