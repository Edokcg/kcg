-- 不死之元素英雄 暴风侠(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    -- fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c, true, true, 77240364, 1, s.ofilter, 2)
    Fusion.AddContactProc(c, s.contactfil, s.contactop, s.splimit, nil, nil, nil, false)
    -- destroy replace
    local e13 = Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
    e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCode(EFFECT_DESTROY_REPLACE)
    e13:SetTarget(s.reptg)
    c:RegisterEffect(e13)
end

function s.ofilter(c, fc, sumtype, tp)
    return c:IsSetCard(0xa250, fc, sumtype, tp) and c:IsSetCard(0x3008, fc, sumtype, tp) and
               c:IsType(TYPE_MONSTER, fc, sumtype, tp)
end

function s.contactfil(tp)
    return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost, tp, LOCATION_ONFIELD + LOCATION_HAND, 0, nil)
end

function s.contactop(g, tp)
    Duel.ConfirmCards(1 - tp, g)
    Duel.SendtoGrave(g, REASON_COST + REASON_MATERIAL)
end

function s.splimit(e, se, sp, st)
    return (st & SUMMON_TYPE_FUSION) == SUMMON_TYPE_FUSION
end

function s.repfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa250) and c:IsAbleToGrave()
end

function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return c:IsReason(REASON_BATTLE + REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and
                   Duel.IsExistingMatchingCard(s.repfilter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler())
    end
    if Duel.SelectEffectYesNo(tp, c, 96) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESREPLACE)
        local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler())
        Duel.SendtoGrave(g, REASON_EFFECT + REASON_REPLACE)
        return true
    else
        return false
    end
end

