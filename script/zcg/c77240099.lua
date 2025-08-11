--精灵的宝石
function c77240099.initial_effect(c)
    --battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(aux.imval1)
    c:RegisterEffect(e1)
	
    --Atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
    e2:SetValue(500)
    c:RegisterEffect(e2)
	
    --Atk down
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
    e3:SetValue(-500)
    c:RegisterEffect(e3)
end
