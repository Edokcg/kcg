--遊城十代
local s, id = GetID()
function s.initial_effect(c)
	local ge2 = Effect.CreateEffect(c)
    ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_PREDRAW)
    ge2:SetCondition(s.drcon)
    ge2:SetOperation(s.drop)
    Duel.RegisterEffect(ge2, 0)
    local ge3 = ge2:Clone()
    Duel.RegisterEffect(ge3, 1)

    local ge4 = Effect.CreateEffect(c)
    ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    ge4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge4:SetCode(EVENT_PREEFFECT_DRAW)
    ge4:SetCondition(s.drcon2)
    ge4:SetOperation(s.drop2)
    Duel.RegisterEffect(ge4, 0)
    local ge5 = ge4:Clone()
    Duel.RegisterEffect(ge5, 1)

	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRECHAINING)
    e1:SetCondition(s.act20condition)
    e1:SetOperation(s.activate2)
    e1:SetCountLimit(1)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.act20condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 92999980) ~= 0 
    and (Duel.GetLP(1 - tp) >= Duel.GetLP(tp) + 4000) 
    and re:GetHandler():IsControler(tp) 
    and re:GetHandler():IsCode(18631392)
    and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) and Duel.GetTurnPlayer() == tp
end
function s.activate2(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetDecktopGroup(tp, 1)
    if not g or not Duel.SelectYesNo(tp,aux.Stringid(id, 1)) then return end
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(id, 1))
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    s.KDraw(tp, 1)
end

function s.drcon2(e, tp, eg, ep, ev, re, r, rp)
    return ep == tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
end
function s.drop2(e, tp, eg, ep, ev, re, r, rp)
    local count = ev
    if ev > count then count = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) end
    s.KDraw(tp, count)
end

function s.KDraw(ttp, count)
    local e = Effect.GlobalEffect()
    if Duel.GetTurnCount() ~= 1 and Duel.GetMatchingGroupCount(nil, ttp, LOCATION_DECK, 0, nil) > 0 and
        (Duel.GetFlagEffect(ttp, 92999980) ~= 0 and (Duel.GetLP(1 - ttp) - Duel.GetLP(ttp)) >= 4000) then

        if Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_SPELL) > 0 and Duel.SelectYesNo(ttp, aux.Stringid(123106, 7)) then
            local g = Duel.GetMatchingGroup(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_SPELL)
            local g2 = g:RandomSelect(ttp, count)
            if #g2<1 then return end
            local tacg2 = Duel.GetDecktopGroup(ttp, #g2)
            if #tacg2<1 then return end
            aux.SwapEntity(g2, tacg2)
            if Duel.GetFlagEffect(ttp, 89999995) ~= 0 then
                Duel.Hint(HINT_CARD, 0, 510000106)
            end
            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(123106, 7))
        end
    end
end