--特殊系統卡 風暴連線
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(826, 5))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(s.lmCondition)
    e1:SetOperation(s.lmOperation)
    Duel.RegisterEffect(e1,0)
    local e10 = e1:Clone()
    Duel.RegisterEffect(e10, 1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TOSS_DICE_NEGATE)
    e2:SetCondition(s.lmCondition2)
    e2:SetOperation(s.lmOperation2)
    Duel.RegisterEffect(e2,0)
    local e20 = e2:Clone()
    Duel.RegisterEffect(e20, 1)

    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(826, 8))
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetCondition(s.lmCondition3)
    e3:SetOperation(s.lmOperation3)
    Duel.RegisterEffect(e3,0)
    local e30 = e3:Clone()
    Duel.RegisterEffect(e30, 1)

    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(826, 9))
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e4:SetType(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_DUEL)
    e4:SetCondition(s.lmCondition4)
    e4:SetOperation(s.lmOperation4)
    Duel.RegisterEffect(e4,0)
    local e40 = e4:Clone()
    Duel.RegisterEffect(e40, 1)
end

function s.usefilter(c)
    return c:IsType(TYPE_LINK) and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(false, false, false) ~= nil
end
function s.lmCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 784) ~= 0 and Duel.GetLP(tp) <= Duel.GetFlagEffectLabel(tp, 784) 
    and Duel.GetMatchingGroupCount(s.usefilter, tp, LOCATION_DECK, 0, nil) > 0
end
function s.lmOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(826, 5))
    local g = Duel.GetMatchingGroup(s.usefilter, tp, LOCATION_DECK, 0, nil)
    Duel.ConfirmCards(tp, g)
    local g2 = g:Select(tp, 1, 1, nil)
    local tc = g2:GetFirst()
    if tc then
        local te, eg, ep, ev, re, r, rp = tc:CheckActivateEffect(true, true, true)
        local tep = tc:GetControler()
        local condition = te:GetCondition()
        local operation = te:GetOperation()
        if not Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
            return
        end
        Duel.Hint(HINT_CARD, 0, tc:GetOriginalCode())
        tc:CreateEffectRelation(te)
        Duel.BreakEffect()
        if operation then
            operation(te, tep, eg, ep, ev, re, r, rp)
        end
        tc:ReleaseEffectRelation(te)

        Duel.ShuffleDeck(tp)

        local e1 = Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SINGLE_RANGE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetRange(LOCATION_SZONE)
        e1:SetCode(EFFECT_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1, true)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2, true)
    end
end

function s.lusefilter(c)
    return c:IsSetCard(0x577) and c:IsType(TYPE_LINK)
end
function s.lmCondition2(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 784) ~= 0 and Duel.GetMatchingGroupCount(s.lusefilter, tp, 0xff, 0, nil) > 0
end
function s.lmOperation2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    if Duel.SelectYesNo(tp, aux.Stringid(35772782, 1)) then
        local dc = {Duel.GetDiceResult()}
        local ac = 1
        local val, val2
        local ct = bit.band(ev, 0xff) + bit.rshift(ev, 16)
        Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(35772782, 2))
        val = Duel.AnnounceNumber(tp, 1, 2, 3, 4, 5, 6)
        dc[0] = val
        Duel.SetDiceResult(val)
    end
end

function s.lmCondition3(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFlagEffect(tp, 784) ~= 0 
    and Duel.GetTurnPlayer() == tp 
    and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
end
function s.lmOperation3(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(826, 8))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
    local code = Duel.AnnounceCard(tp, RACE_CYBERSE, OPCODE_ISRACE,OPCODE_ALLOW_ALIASES)
    local token = Duel.CreateToken(tp, code)
    if token:IsRace(RACE_CYBERSE) then
        Duel.SendtoDeck(token, tp, 0, REASON_RULE)
    end
end

function s.lmCondition4(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp 
    and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetFlagEffect(tp, 784) ~= 0 and Duel.GetLP(tp) <= 1000
end
function s.lmOperation4(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(826, 9))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
    local code = Duel.AnnounceCard(tp, RACE_CYBERSE, OPCODE_ISRACE,OPCODE_ALLOW_ALIASES)
    local token = Duel.CreateToken(tp, code)
    if token:IsRace(RACE_CYBERSE) then
        Duel.SendtoDeck(token, tp, 0, REASON_RULE)
    end
end