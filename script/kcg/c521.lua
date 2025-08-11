--榊遊矢/扎克 (K)
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
        (Duel.GetFlagEffect(ttp, 703) ~= 0 and
            ((Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 16195942) > 0 and
                Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x95) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 42160203) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x95) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 90036274) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_TUNER) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 82044279) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_TUNER) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 70771599) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_TUNER) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 41209827) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x46) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 511009415) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x46) > 0) or
                (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 43387895) > 0 and
                    Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x46) > 0))) then

        if Duel.SelectYesNo(ttp, aux.Stringid(827, 1)) then
            local off = 1
            local ops = {}
            local opval = {}
            if (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 16195942) > 0 or Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 42160203) > 0) 
            and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x95) > 0 then
                ops[off] = aux.Stringid(827, 2)
                opval[off - 1] = 1
                off = off + 1
            end
            if (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 90036274) > 0 
            or Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 82044279) > 0 
            or Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 70771599) > 0) 
            and Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_TUNER) > 0 then
                ops[off] = aux.Stringid(827, 3)
                opval[off - 1] = 2
                off = off + 1
            end
            if (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 41209827) > 0 
            or Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 511009415) > 0 
            or Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_MZONE, 0, nil, 43387895) > 0) 
            and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x46) > 0 then
                ops[off] = aux.Stringid(827, 4)
                opval[off - 1] = 3
                off = off + 1
            end
            local op = Duel.SelectOption(ttp, table.unpack(ops))
            if opval[op] == 1 then
                Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                local destinytc = Duel.SelectMatchingCard(ttp, Card.IsSetCard, ttp, LOCATION_DECK, 0, 1, 1, nil, 0x95):GetFirst()
                if not destinytc then return end
                Duel.ShuffleDeck(ttp)  
                local tacg2 = Duel.GetDecktopGroup(ttp, 1)
                if #tacg2<1 then return end
                local tac2 = tacg2:GetFirst()
                aux.SwapEntity(destinytc, tac2)
                Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(827, 1))
            end
            if opval[op] == 2 then
                Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                local destinytc = Duel.SelectMatchingCard(ttp, Card.IsType, ttp, LOCATION_DECK, 0, 1, 1, nil, TYPE_TUNER):GetFirst()
                if not destinytc then return end
                Duel.ShuffleDeck(ttp)
                local tac2 = tacg2:GetFirst()
                if not tac2 then return end
                aux.SwapEntity(destinytc, tac2)
                Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(827, 1))
            end
            if opval[op] == 3 then
                Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                local destinytc = Duel.SelectMatchingCard(ttp, Card.IsSetCard, ttp, LOCATION_DECK, 0, 1, 1, nil, 0x46):GetFirst()
                if not destinytc then return end
                Duel.ShuffleDeck(ttp)
                local tacg2 = Duel.GetDecktopGroup(ttp, 1)
                if #tacg2<1 then return end
                local tac2 = tacg2:GetFirst()
                aux.SwapEntity(destinytc, tac2)
                Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(827, 1))
            end
        end
    end
end