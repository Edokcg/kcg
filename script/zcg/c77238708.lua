--CF-SPAS12 散弹枪(ZCG)
function c77238708.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77238708.val)
    c:RegisterEffect(e1)
end
function c77238708.val(e,c)
    return Duel.GetMatchingGroupCount(aux.TRUE,c:GetControler(),LOCATION_SZONE,LOCATION_SZONE,nil)*300
end

