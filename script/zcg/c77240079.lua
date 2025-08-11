--狂暴盔甲兽
function c77240079.initial_effect(c)
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c77240079.val)
    c:RegisterEffect(e1)
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
end
function c77240079.val(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*500
end
