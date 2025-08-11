-- 不死之元素英雄 锯齿荒野侠(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    -- fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c, true, true, 77240361, 1, s.ofilter, 1)
    Fusion.AddContactProc(c, s.contactfil, s.contactop, s.splimit, nil, nil, nil, false)
    -- attackall
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    -- double
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetCondition(s.damcon)
    e3:SetOperation(s.damop)
    c:RegisterEffect(e3)
end

function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return ep ~= tp and e:GetHandler():GetBattleTarget() ~= nil
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
    Duel.ChangeBattleDamage(ep, ev * 2)
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
