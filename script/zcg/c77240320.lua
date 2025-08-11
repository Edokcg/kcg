--太阳神之封印剑(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --attack cost
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_EQUIP)
    e8:SetCode(EFFECT_ATTACK_COST)
    e8:SetOperation(s.atop)
    c:RegisterEffect(e8)
    --negate
    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_CHAINING)
    e11:SetRange(LOCATION_SZONE)
    e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL + EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetCondition(s.negcon)
    e11:SetOperation(s.atop)
    c:RegisterEffect(e11)
    --tohand
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_LEAVE_FIELD)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_CAL)
    e10:SetCondition(s.negcon2)
    e10:SetOperation(s.atop)
    c:RegisterEffect(e10)
    --disable effect
    local e52 = Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_ONFIELD)
    e52:SetOperation(s.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53 = Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_ONFIELD)
    e53:SetTargetRange(0xa, 0xa)
    e53:SetTarget(s.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54 = Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_ONFIELD)
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

function s.negcon(e, tp, eg, ep, ev, re, r, rp)
    local rc = re:GetHandler()
    local tc = e:GetHandler():GetEquipTarget()
    return not tc:IsStatus(STATUS_BATTLE_DESTROYED)
        and rc == tc
end

function s.negcon2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ec = c:GetPreviousEquipTarget()
    return c:IsReason(REASON_LOST_TARGET) or ec:IsReason(REASON_RELEASE)
end

function s.atop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetHandler():GetPreviousEquipTarget()
    local tps = tc:GetControler()
    Duel.PayLPCost(tps, 800)
    Duel.AttackCostPaid()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
    Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp, e:GetHandler(), tc)
    end
end
