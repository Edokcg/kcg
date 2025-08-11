--太阳神之火炎之子(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --summon
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --search
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 0))
    e4:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1, 0, EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(s.cost)
    e4:SetOperation(s.atkop)
    c:RegisterEffect(e4)
    --search
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id, 1))
    e5:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1, 0, EFFECT_COUNT_CODE_SINGLE)
    e5:SetCost(s.cost2)
    e5:SetTarget(s.target)
    e5:SetOperation(s.activate)
    c:RegisterEffect(e5)
    --search
    local e6 = Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id, 2))
    e6:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1, 0, EFFECT_COUNT_CODE_SINGLE)
    e6:SetCost(s.cost3)
    e6:SetTarget(s.target2)
    e6:SetOperation(s.activate2)
    c:RegisterEffect(e6)

    --Attribute
    local e51 = Effect.CreateEffect(c)
    e51:SetType(EFFECT_TYPE_SINGLE)
    e51:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e51:SetCode(EFFECT_ADD_ATTRIBUTE)
    e51:SetRange(LOCATION_MZONE)
    e51:SetValue(ATTRIBUTE_DARK + ATTRIBUTE_EARTH + ATTRIBUTE_FIRE + ATTRIBUTE_LIGHT + ATTRIBUTE_WATER + ATTRIBUTE_WIND)
    c:RegisterEffect(e51)
    --disable effect
    local e52 = Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(s.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53 = Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa, 0xa)
    e53:SetTarget(s.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54 = Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa, 0xa)
    e54:SetTarget(s.distg2)
    c:RegisterEffect(e54)
end

-------------------------------------------------------------------------
function s.disop2(e, tp, eg, ep, ev, re, r, rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(), REASON_EFFECT)
            end
        end
    end
end

function s.distg2(e, c)
    return c:GetCardTargetCount() > 0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local ct = c:GetAttack()
        if ct > 0 then
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(ct * 2)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
            c:RegisterEffect(e1)
        end
    end
end

function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 2, e:GetHandler()) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 2, 2, REASON_COST + REASON_DISCARD)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_SZONE, 1, c) end
    local sg = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_SZONE, c)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, sg:GetCount(), 0, 0)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_SZONE, nil)
    Duel.Destroy(sg, REASON_EFFECT)
end

function s.cost3(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 3, e:GetHandler()) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 3, 3, REASON_COST + REASON_DISCARD)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, c) end
    local sg = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_ONFIELD, c)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, sg:GetCount(), 0, 0)
end

function s.activate2(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_ONFIELD, nil)
    Duel.Destroy(sg, REASON_EFFECT)
end

function s.rfilter(c, tp)
    return c:IsSetCard(0xa210) and (c:IsControler(tp) or c:IsFaceup())
end

function s.mzfilter(c, tp)
    return c:IsControler(tp) and c:GetSequence() < 5
end

function s.spcon(e, c)
    if c == nil then return true end
    local tp = c:GetControler()
    local rg = Duel.GetReleaseGroup(tp):Filter(s.rfilter, nil, tp)
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local ct = -ft + 1
    return ft > -3 and rg:GetCount() > 2 and (ft > 0 or rg:IsExists(s.mzfilter, ct, nil, tp))
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    local rg = Duel.GetReleaseGroup(tp):Filter(s.rfilter, nil, tp)
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local g = nil
    if ft > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
        g = rg:Select(tp, 3, 3, nil)
    elseif ft > -2 then
        local ct = -ft + 1
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
        g = rg:FilterSelect(tp, s.mzfilter, ct, ct, nil, tp)
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
        local g2 = rg:Select(tp, 3 - ct, 3 - ct, g)
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
        g = rg:FilterSelect(tp, s.mzfilter, 3, 3, nil, tp)
    end
    Duel.Release(g, REASON_COST)
end
