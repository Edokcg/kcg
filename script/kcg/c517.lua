--紅龍印記
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
    return Duel.GetFlagEffect(tp, 93999980) ~= 0 
    and (Duel.GetLP(1 - tp) >= Duel.GetLP(tp)) 
    and re:GetHandler():IsControler(tp) 
    and re:GetHandler():IsCode(24696097)
    and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) and Duel.GetTurnPlayer() == tp
    and Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_DECK, 0, 1, nil, TYPE_TUNER)
end
function s.activate2(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_DECK, 0, nil, TYPE_TUNER)
    if #g<1 then return end
    if g:GetCount() >= 5 then
        g = g:RandomSelect(tp, 5)
    end
    if g:GetCount() < 5 then
        g = g:RandomSelect(tp, g:GetCount())
    end
    local tac2=Duel.GetDecktopGroup(tp, #g)
    if #tac2<1 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
    aux.SwapEntity(g, tac2)
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
        (Duel.GetFlagEffect(ttp, 93999980) ~= 0 and Duel.GetLP(1 - ttp) >= Duel.GetLP(ttp) and
                Duel.GetFlagEffect(ttp, 99999960) == 0 and
                (Duel.GetMatchingGroupCount(s.RDSfiler, ttp, LOCATION_MZONE, 0, nil) > 0 or
                    (Duel.GetMatchingGroupCount(s.RRDSfiler, ttp, LOCATION_MZONE, 0, nil) > 0 and
                        Duel.GetMatchingGroupCount(s.RRDSfiler2, ttp, LOCATION_MZONE, 0, nil, 1) > 0))) then

        if Duel.GetMatchingGroupCount(s.RDSfiler, ttp, LOCATION_MZONE, 0, nil) > 0 
            and Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND + LOCATION_REMOVED, 0, nil, 21159309) < 3 and Duel.SelectYesNo(ttp, aux.Stringid(517, 1)) then
            if Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK, 0, nil, 21159309) == 0 then
                local token = Duel.CreateToken(ttp, 21159309, nil, nil, nil, nil, nil, nil)
                Duel.DisableShuffleCheck()
                Duel.SendtoDeck(token, ttp, 0, REASON_RULE)
            else
                local destinytc = Duel.GetFirstMatchingCard(Card.IsCode, ttp, LOCATION_DECK, 0, nil, 21159309)      
                local tacg2 = Duel.GetDecktopGroup(ttp, 1)
                if #tacg2<1 then return end
                local tac2 = tacg2:GetFirst()
                aux.SwapEntity(destinytc, tac2)
            end
            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(517, 1))
            Duel.RegisterFlagEffect(ttp, 99999960, 0, 0, 1)
        end
    end
end

function s.RDSfiler(c)
    return c:IsCode(44508094) or c:IsCode(70902743)
end
function s.RRDSfiler(c)
    return c:IsCode(2403771)
end
function s.RRDSfiler2(c, qt)
    return c:IsType(TYPE_TUNER) and c:GetLevel() == qt
end