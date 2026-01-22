local s, id = GetID()
function s.initial_effect(c)
    if not AI then
    AI = {}
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_STARTUP)
    e1:SetOperation(s.op)
    Duel.RegisterEffect(e1, 0)
    end
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetMatchingGroupCount(Card.IsCode, 0, LOCATION_EXTRA, LOCATION_EXTRA, nil, id) > 0 then
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, LOCATION_EXTRA, nil, id),0,-2,REASON_RULE)
    end
    e:Reset()
end
