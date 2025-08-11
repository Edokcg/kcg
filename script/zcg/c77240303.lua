--冥界亡灵（ZCG）
local s, id = GetID()
function s.initial_effect(c)
    --special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --disable summon
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(0, 1)
    c:RegisterEffect(e2)
    local e3 = e2:Clone()
    e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e3)
    local e4 = e2:Clone()
    e4:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e4)
    local e5 = e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e5)
    local e6 = e4:Clone()
    e6:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e6)
    local e7 = e2:Clone()
    e7:SetCode(EFFECT_CANNOT_ACTIVATE)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e8:SetCode(EFFECT_IMMUNE_EFFECT)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(s.efilter)
    c:RegisterEffect(e8)
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetCategory(CATEGORY_DAMAGE)
    e9:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetCondition(s.damcon)
    e9:SetTarget(s.damtg)
    e9:SetOperation(s.damop)
    c:RegisterEffect(e9)
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e10)
    local e11 = e10:Clone()
    e11:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    c:RegisterEffect(e11)
end

function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() ~= tp
end

function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, 0, 0, tp, 1000)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
end

function s.efilter(e, te)
    return te:GetOwner() ~= e:GetOwner()
end

function s.spcon(e, c)
    if c == nil then return true end
    return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
        Duel.CheckLPCost(c:GetControler(), 1500)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.PayLPCost(tp, 1500)
end
