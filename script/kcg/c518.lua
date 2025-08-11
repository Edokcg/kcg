--心靈透視 (K)
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE_START + PHASE_MAIN1)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCountLimit(1)
    e1:SetCondition(s.MCondition)
    e1:SetOperation(s.MOp)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.DTMfiler(c, tp)
    return Duel.GetMatchingGroupCount(s.DTMfiler2, tp, LOCATION_DECK + LOCATION_HAND, 0, nil) > 0 
    and Duel.GetMatchingGroupCount(Card.IsCode, tp, LOCATION_DECK + LOCATION_HAND, 0, nil, 15259703) > 0
end
function s.DTMfiler2(c)
    return c:IsSetCard(0x62) and c:IsType(TYPE_MONSTER)
end
function s.DTMfiler3(c)
    return c:IsSetCard(0x62) and c:IsFaceup()
end
function s.DTMfiler4(c)
    return c:IsCode(15259703) and c:IsFaceup()
end
function s.MCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 90899980) ~= 0 
    and Duel.GetMatchingGroupCount(s.DTMfiler3, tp, LOCATION_MZONE, 0, nil) > 0 
    and Duel.GetMatchingGroupCount(s.DTMfiler4, tp, LOCATION_SZONE, 0, nil) > 0
end
function s.MOp(e, tp, eg, ep, ev, re, r, rp)
    if Duel.SelectYesNo(tp, aux.Stringid(826, 7)) then
        Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(826, 7))
        local dg = Duel.GetFieldGroup(tp, 0, LOCATION_ONFIELD + LOCATION_HAND)
        Duel.ConfirmCards(tp, dg)
    end
end