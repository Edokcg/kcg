-- 不死之欧贝利斯克·巨神兵
function c77238100.initial_effect(c)
    c:EnableReviveLimit()

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)

    -- special summon summon from hand
    local e1 = Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77238100.ttcon)
    e1:SetOperation(c77238100.ttop)
    e1:SetValue(SUMMON_TYPE_TRIBUTE)
    c:RegisterEffect(e1)
    --[[cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --tribute limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRIBUTE_LIMIT)
    e2:SetValue(c77238100.tlimit)
    c:RegisterEffect(e2)
    --summon with 3 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238100,0))
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e3:SetCondition(c77238100.ttcon)
    e3:SetOperation(c77238100.ttop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_LIMIT_SET_PROC)
    c:RegisterEffect(e4)]]

    -- summon
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e5)
    -- summon success
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetOperation(c77238100.sumsuc)
    c:RegisterEffect(e6)

    -- destroy
    local e7 = Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77238100, 1))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77238100.descost)
    e7:SetTarget(c77238100.destg)
    e7:SetOperation(c77238100.desop)
    c:RegisterEffect(e7)

    -- attack all
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_ATTACK_ALL)
    e8:SetValue(1)
    c:RegisterEffect(e8)

    -- actlimit
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetCode(EFFECT_CANNOT_ACTIVATE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(0, 1)
    e9:SetValue(c77238100.aclimit)
    e9:SetCondition(c77238100.actcon)
    c:RegisterEffect(e9)
end

---------------------------------------------------------------------
--[[function c77238100.tlimit(e,c)
    return not c:IsRace(RACE_ZOMBIE)
end
function c77238100.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77238100.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end]]
function c77238100.otfilter(c, tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end

function c77238100.ttcon(e, c, minc)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    local mg = Duel.GetMatchingGroup(c77238100.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    return minc <= 1 and Duel.CheckTribute(c, 3, 3, mg)
end

function c77238100.ttop(e, tp, eg, ep, ev, re, r, rp, c)
    local mg = Duel.GetMatchingGroup(c77238100.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    local sg = Duel.SelectTribute(tp, c, 3, 3, mg)
    c:SetMaterial(sg)
    Duel.Release(sg, REASON_SUMMON + REASON_MATERIAL)
end

---------------------------------------------------------------------
function c77238100.sumsuc(e, tp, eg, ep, ev, re, r, rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

---------------------------------------------------------------------
function c77238100.filter(c)
    return c:IsRace(RACE_ZOMBIE)
end

function c77238100.descost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckReleaseGroup(tp, c77238100.filter, 1, nil)
    end
    local g = Duel.SelectReleaseGroup(tp, c77238100.filter, 1, 1, nil)
    Duel.Release(g, REASON_COST)
end

function c77238100.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
    end
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
end

function c77238100.desop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    Duel.Destroy(g, REASON_EFFECT)
end

---------------------------------------------------------------------
function c77238100.aclimit(e, re, tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function c77238100.actcon(e)
    return Duel.GetAttacker() == e:GetHandler()
end
