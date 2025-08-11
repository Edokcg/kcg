--DB-孙悟空-超重拳
function c77240013.initial_effect(c)
    --must attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
