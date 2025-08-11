--不死之蒲公英狮(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --token
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 4, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 4, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    if Duel.IsPlayerAffectedByEffect(tp, 59822133) then return end
    if Duel.GetLocationCount(tp, LOCATION_MZONE) < 4 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp, 77240352, 0, TYPES_TOKEN, 0, 0, 1, RACE_ZOMBIE, ATTRIBUTE_DARK) then return end
    for i = 1, 4 do
        local token = Duel.CreateToken(tp, 77240352)
        Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
    end
    Duel.SpecialSummonComplete()
end
