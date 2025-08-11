--特殊系統卡 幻魔
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(826, 10))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(s.phantomCondition)
    e1:SetOperation(s.phantomOperation)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.phantomCondition(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnPlayer() == tp and Duel.GetFlagEffect(tp, 10000004) ~= 0 
    and (Duel.GetMatchingGroupCount(Card.IsCode, tp, LOCATION_DECK, 0, nil, 69890967) > 0 or
        Duel.GetMatchingGroupCount(Card.IsCode, tp, LOCATION_DECK, 0, nil, 32491822) > 0 or
        Duel.GetMatchingGroupCount(Card.IsCode, tp, LOCATION_DECK, 0, nil, 6007213) > 0) 
    and Duel.GetMatchingGroupCount(nil, tp, LOCATION_HAND, 0, nil) > 0
end
function s.phantomOperation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(826, 10))
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g1 = Duel.SelectMatchingCard(tp, Card.IsCode, tp, LOCATION_DECK, 0, 1, 1, nil, 69890967, 32491822, 6007213):GetFirst()
    if not g1 then return end
    local type = 0
    if g1:IsCode(69890967) then
        type = TYPE_MONSTER
    end
    if g1:IsCode(32491822) then
        type = TYPE_SPELL
    end
    if g1:IsCode(6007213) then
        type = TYPE_TRAP
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g2 = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
    if not g2 then return end
    Duel.ShuffleDeck(tp)
    aux.SwapEntity(g1, g2)
    if Duel.GetMatchingGroupCount(nil, tp, LOCATION_HAND, 0, nil) > 0 and
        Duel.GetMatchingGroupCount(Card.IsType, tp, LOCATION_DECK, 0, nil, type) > 0 and
        Duel.SelectYesNo(tp, aux.Stringid(826, 10)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
        local g1 = Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_DECK, 0, 1, 1, nil, type):GetFirst()
        if not g1 then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
        local g2 = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
        if not g2 then return end
        Duel.ShuffleDeck(tp)
        aux.SwapEntity(g1, g2)
    end
end
