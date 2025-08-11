--特殊系統卡 同調殺手
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(827, 7))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(s.synkillCondition)
    e1:SetOperation(s.synkillOperation)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.synkillCondition(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnPlayer() == tp and Duel.GetFlagEffect(tp, 108) ~= 0 
        and Duel.GetMatchingGroupCount(Card.IsCode, tp, LOCATION_DECK, 0, nil, 100000055, 100000066, 100000067) > 0
        and Duel.GetMatchingGroupCount(nil, tp, LOCATION_HAND, 0, nil) > 0
end
function s.synkillOperation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(827, 7))
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g1 = Duel.SelectMatchingCard(tp, Card.IsCode, tp, LOCATION_DECK, 0, 1, 1, nil, 100000055, 100000066, 100000067):GetFirst()
    if not g1 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g2 = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
    if not g2 then return end
    Duel.ShuffleDeck(tp)
    aux.SwapEntity(g1, g2)
    if Duel.GetMatchingGroupCount(nil, tp, LOCATION_HAND, 0, nil) > 0 and
        Duel.SelectYesNo(tp, aux.Stringid(827, 7)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
        local g1 = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()
        if not g1 then return end
        Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
        local g2 = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
        if not g2 then return end
        Duel.ShuffleDeck(tp)
        aux.SwapEntity(g1, g2)
    end
end