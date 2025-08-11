--DB-孙悟空-夺取超圣水
function c77240015.initial_effect(c)
    --attack up
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(6669086,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(c77240015.operation)
    c:RegisterEffect(e1)
end
function c77240015.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(e:GetHandler():GetAttack()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)   
    --direct attack
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e2)   
end
