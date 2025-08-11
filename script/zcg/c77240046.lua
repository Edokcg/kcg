--大地的龙脉
function c77240046.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
    e2:SetValue(800)
    c:RegisterEffect(e2)
end
