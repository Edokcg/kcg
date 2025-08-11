-- 不死之奥西里斯·天空龙(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)

    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 1))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(s.ttcon)
    e1:SetOperation(s.ttop)
    e1:SetValue(SUMMON_TYPE_TRIBUTE)
    c:RegisterEffect(e1)
    -- summon
    local e30 = Effect.CreateEffect(c)
    e30:SetType(EFFECT_TYPE_SINGLE)
    e30:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e30:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e30)
    -- summon success
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetOperation(s.sumsuc)
    c:RegisterEffect(e6)
    --
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_UPDATE_ATTACK)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetValue(s.atkval)
    c:RegisterEffect(e10)
    -- atkdown
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id, 1))
    e8:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_DESTROY)
    e8:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetCondition(s.atkcon)
    e8:SetTarget(s.atktg)
    e8:SetOperation(s.atkop)
    c:RegisterEffect(e8)
    local e9 = e8:Clone()
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e9)
end

function s.otfilter(c, tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end

function s.ttcon(e, c, minc)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    return minc <= 1 and Duel.CheckTribute(c, 3, 3, mg)
end

function s.ttop(e, tp, eg, ep, ev, re, r, rp, c)
    local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    local sg = Duel.SelectTribute(tp, c, 3, 3, mg)
    c:SetMaterial(sg)
    Duel.Release(sg, REASON_SUMMON + REASON_MATERIAL)
end

function s.sumsuc(e, tp, eg, ep, ev, re, r, rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

function s.atkfilter(c, tp)
    return c:IsControler(1 - tp) and c:IsPosition(POS_FACEUP_ATTACK)
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.atkfilter, 1, nil, tp)
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsRelateToEffect(e)
    end
    Duel.SetTargetCard(eg)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetTargetCards(e):Filter(Card.IsFaceup, nil)
    if #g == 0 then
        return
    end
    local dg = Group.CreateGroup()
    local c = e:GetHandler()
    for tc in aux.Next(g) do
        local preatk = tc:GetAttack()
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
        if preatk ~= 0 and tc:GetAttack() == 0 then
            dg:AddCard(tc)
        end
    end
    if #dg == 0 then
        return
    end
    Duel.BreakEffect()
    Duel.Destroy(dg, REASON_EFFECT)
end

function s.atkfilter2(c)
    return c:IsSetCard(0xa250) and c:IsType(TYPE_MONSTER)
end

function s.atkval(e, c)
    local tp = e:GetHandler():GetControler()
    local g = Duel.GetMatchingGroup(s.atkfilter2, tp, LOCATION_HAND, 0, e:GetHandler())
    local atk = g:GetSum(Card.GetAttack)
    return math.ceil(atk)
end

function s.aclimit(e, re, tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.actcon(e)
    return Duel.GetAttacker() == e:GetHandler()
end

function s.otfilter(c, tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
