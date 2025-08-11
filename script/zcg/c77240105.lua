--狮王之魂
function c77240105.initial_effect(c)
    --disable spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetTarget(c77240105.splimit)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e2)	
end
function c77240105.splimit(e,c)
    return c:IsAttackAbove(1800)
end
