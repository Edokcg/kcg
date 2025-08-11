--王之名
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
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRECHAINING)
    e1:SetCondition(s.yugicon)
    e1:SetOperation(s.yugiop)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.yugicon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 90799980) ~= 0 
    and rp == tp
    and Duel.GetLP(tp) <= 2000
    and re:IsHasCategory(CATEGORY_SEARCH) and re:IsHasCategory(CATEGORY_TOHAND)
end
function s.yugiop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local destinytc = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()
    if not destinytc then return end
    Duel.ShuffleDeck(tp)
    local tac2=Duel.GetDecktopGroup(tp, 1):GetFirst()
    if not tac2 then return end
    aux.SwapEntity(destinytc, tac2)
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
        (Duel.GetFlagEffect(ttp, 90799980) ~= 0 and Duel.GetLP(ttp) <= 2000 and
        Duel.GetFieldGroupCount(ttp, LOCATION_HAND, 0) < 3) then

        if Duel.SelectYesNo(ttp, aux.Stringid(826, 6)) then
            Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_CODE)
            local code = Duel.AnnounceCard(ttp, TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK, OPCODE_ISTYPE, OPCODE_NOT, SCOPE_CUSTOM, OPCODE_ISOTYPE, OPCODE_NOT, OPCODE_AND, OPCODE_ALLOW_ALIASES)
            local tg = Duel.GetFirstMatchingCard(Card.IsCode, ttp, LOCATION_DECK, 0, nil, code)
            if tg then
                local tacg2 = Duel.GetDecktopGroup(ttp, 1)
                if #tacg2<1 then return end
                local tac2 = tacg2:GetFirst()
                aux.SwapEntity(tg, tac2)
            else
                local token = Duel.CreateToken(ttp, code)
                Duel.DisableShuffleCheck()
                Duel.SendtoDeck(token, ttp, 0, REASON_RULE)
            end
            if Duel.GetFlagEffect(ttp, 89999993) ~= 0 then
                Duel.Hint(HINT_CARD, 0, 510000108)
            end
            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(826, 6))
        end
    end
end