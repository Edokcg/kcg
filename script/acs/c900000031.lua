-- 暗黑界的混沌王 卡拉列斯
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMix(c, false, false, 99458769, s.ffilter)

    -- 融合特召限制
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(s.splimit)
    c:RegisterEffect(e1)

    -- 墓地暗黑界怪兽数量提升攻击
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    -- 可以丢弃任意数量手牌
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(900000031, 2))
    e3:SetCategory(CATEGORY_HANDES + CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(s.distg)
    e3:SetOperation(s.disop)
    c:RegisterEffect(e3)

    -- 表侧在场时暗黑界怪兽不受对方魔法陷阱影响
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE, 0)
    e4:SetTarget(s.gfilter)
    e4:SetValue(s.efilter)
    c:RegisterEffect(e4)
end
s.listed_series={0x6}
----------------------------------------------------------------------------------------------------------
function s.ffilter(c, fc, sumtype, tp)
    return
        c:IsRace(RACE_FIEND, fc, sumtype, tp) and c:IsAttribute(ATTRIBUTE_DARK, fc, sumtype, tp) and c:GetControler() ~=
            tp and c:IsLocation(LOCATION_MZONE)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.splimit(e, se, sp, st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st, SUMMON_TYPE_FUSION) == SUMMON_TYPE_FUSION
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.dfilter(c)
    return c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
end

function s.atkval(e, c)
    return Duel.GetMatchingGroupCount(s.dfilter, c:GetControler(), LOCATION_GRAVE, 0, nil, TYPE_TUNER) * 500
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ct = Duel.DiscardHand(tp, aux.TRUE, 1, 99, REASON_EFFECT + REASON_DISCARD)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.gfilter(e, c)
    return c:IsFaceup() and c:IsSetCard(0x6) and c:IsType(TYPE_MONSTER)
end

function s.efilter(e, te)
    return te:IsActiveType(TYPE_SPELL + TYPE_TRAP) and te:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end
