--特殊系統卡 罪
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(827, 5))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(s.sinCondition)
    e1:SetOperation(s.sinOperation)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.sinfilter(c)
    return not c:IsSetCard(0x23) and c:IsRace(RACE_DRAGON)
end
function s.sinCondition(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnPlayer() == tp and Duel.GetFlagEffect(tp, 107) ~= 0 and Duel.GetMatchingGroupCount(s.sinfilter, tp, LOCATION_HAND, 0, nil) > 0
end
function s.sinOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local destinytc = Duel.SelectMatchingCard(tp, s.sinfilter, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
    if not destinytc then return end
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(827, 5))
    destinytc:SetEntityCode(102, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
end