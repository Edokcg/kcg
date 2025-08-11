-- CNo. 混沌超量體
local s, id = GetID()
function s.initial_effect(c)
    s.cefflist={}
    c:EnableReviveLimit()

    -- battle indestructable
    local e3 = Effect.CreateEffect(c)
    -- e3:SetDescription(aux.Stringid(id,0),true)
    -- e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard, 0x48)))
    c:RegisterEffect(e3)
end
s.listed_series = {0x48}
