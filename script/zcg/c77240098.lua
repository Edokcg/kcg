--神官的千年守墓者
function c77240098.initial_effect(c)
    --send replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c77240098.repcon)
    e1:SetOperation(c77240098.repop)
    c:RegisterEffect(e1)
end
function c77240098.repcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE)
end
function c77240098.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SendtoHand(c,c,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,c)
end