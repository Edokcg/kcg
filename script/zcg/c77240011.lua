--DB-基纽特种部队-基纽
function c77240011.initial_effect(c)
    --direct attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90810762,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCondition(c77240011.atkcon)
    e2:SetOperation(c77240011.atkop)
    c:RegisterEffect(e2)
end
function c77240011.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.GetAttackTarget()==nil
end
function c77240011.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
