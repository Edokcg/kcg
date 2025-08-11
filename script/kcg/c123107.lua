-- Mirror Knight Calling
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	
    -- Special Summon Tokens
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    e11:SetRange(LOCATION_ONFIELD)
    e11:SetTarget(s.target2)
    e11:SetOperation(s.operation2)
    c:RegisterEffect(e11)

    -- Renew Mirror Shields
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetCountLimit(1)
    e2:SetTarget(s.addct)
    e2:SetOperation(s.renop)
    c:RegisterEffect(e2)
end
s.listed_names={123131}

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
                   Duel.IsPlayerCanSpecialSummonMonster(tp, 123131, 0, 0x4011, 0, 0, 1, RACE_WARRIOR, ATTRIBUTE_DARK)
    end
    local count = Duel.GetLocationCount(tp, LOCATION_MZONE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, count, tp, 0)
    Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, count, tp, 0)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) == 0 then
        return
    end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp, 123131, 0, 0x4011, 0, 0, 1, RACE_WARRIOR, ATTRIBUTE_DARK) then
        return
    end
    local count = Duel.GetLocationCount(tp, LOCATION_MZONE)
    count = math.min(count, 4)
    if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then
        count = 1
    end
    for i = 1, count do
        local token = Duel.CreateToken(tp, 123131)
        if Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP) and e:GetHandler():GetFlagEffect(123107) ==
            0 then
            e:GetHandler():RegisterFlagEffect(123107, RESET_EVENT + 0x1ff0000, 0, 1)
        end
        local e1 = Effect.CreateEffect(token)
        e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetCode(EFFECT_DESTROY_REPLACE)
        e1:SetTarget(s.reptg)
        e1:SetRange(LOCATION_ONFIELD)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e1, true)

        local e2 = Effect.CreateEffect(token)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCondition(s.adcon)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD)
        e2:SetValue(s.adval)
		token:RegisterEffect(e2, true)
	end
	Duel.SpecialSummonComplete()
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return eg:FilterCount(s.repfilter2, nil) > 0 and e:GetHandler():GetFlagEffect(123107) > 0
    end
end
function s.repfilter2(c)
    return c:IsCode(123131) and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED + STATUS_BATTLE_DESTROYED)
end
function s.operation2(e, tp, eg, ep, ev, re, r, rp)
    local g = eg:Filter(s.repfilter2, nil)
    local token = g:GetFirst()
    while token do
        if token:AddCounter(0x100, 1) then
            e:GetHandler():ResetFlagEffect(123107)
        end
        token = g:GetNext()
    end
end

function s.adcon(e, tp, eg, ep, ev, re, r, rp)
    local ph = Duel.GetCurrentPhase()
    local c = e:GetHandler()
    return (ph == PHASE_DAMAGE_CAL or ph == PHASE_DAMAGE or Duel.IsDamageCalculated()) and c:IsRelateToBattle() and
               c:GetCounter(0x100) > 0 and c:GetBattleTarget() ~= nil
end
function s.adval(e, c)
    local ph = Duel.GetCurrentPhase()
    local c = e:GetHandler()
    local a = Duel.GetAttacker()
    local d = Duel.GetAttackTarget()
    if (ph == PHASE_DAMAGE_CAL or ph == PHASE_DAMAGE or Duel.IsDamageCalculated()) and c:IsRelateToBattle() and
        c:GetCounter(0x100) > 0 and c:GetBattleTarget() ~= nil then
        if d == c then
            return a:GetAttack()
        end
        if a == c then
            return d:GetAttack()
        end
    end
end

function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():GetCounter(0x100) > 0
    end
    if e:GetHandler():RemoveCounter(tp, 0x100, 1, REASON_EFFECT) then
        return true
    else
        return false
    end
end

function s.repfilter(c)
    return c:IsCode(123131) and c:IsFaceup() and c:IsCanAddCounter(0x100, 1)
end
function s.addct(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    local g = Duel.GetMatchingGroup(s.repfilter, tp, LOCATION_MZONE, 0, nil)
    Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, g:GetCount(), 0, 0x100)
end
function s.renop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then
        return
    end
    local g = Duel.GetMatchingGroup(s.repfilter, tp, LOCATION_MZONE, 0, nil)
    if g:GetCount() < 1 then
        return
    end
    local tc = g:GetFirst()
    while tc do
        if tc:GetCounter(0x100) == 0 then
            tc:AddCounter(0x100, 1)
        end
        tc = g:GetNext()
    end
end
