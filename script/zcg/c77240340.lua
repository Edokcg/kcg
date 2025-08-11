--卡通极神皇 洛基(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixRep(c, true, true, s.ffilter, 3, 99)
    --search
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.srtg)
    e2:SetOperation(s.srop)
    c:RegisterEffect(e2)
    --
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_SZONE, 0)
    e4:SetTarget(s.efilter)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --inactivatable
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_INACTIVATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(s.effectfilter)
    c:RegisterEffect(e5)
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_DISEFFECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(s.effectfilter)
    c:RegisterEffect(e6)
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e8:SetCode(EFFECT_CANNOT_ACTIVATE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(0, 1)
    e8:SetValue(s.aclimit)
    c:RegisterEffect(e8)
    --atk limit
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0, LOCATION_MZONE)
    e3:SetValue(s.atlimit)
    c:RegisterEffect(e3)
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetValue(s.atkval)
    c:RegisterEffect(e9)
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCode(EFFECT_IMMUNE_EFFECT)
    e10:SetValue(s.efilter9)
    c:RegisterEffect(e10)
    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0, LOCATION_MZONE)
    e11:SetCondition(s.actcon)
    e11:SetTarget(s.disable)
    e11:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e11)
    local e12 = Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id, 1))
    e12:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_BATTLE_DESTROYING)
    e12:SetCondition(aux.bdocon)
    e12:SetCondition(s.atcon)
    e12:SetOperation(s.atop)
    c:RegisterEffect(e12)
    --destroy replace
    local e13 = Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
    e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCode(EFFECT_DESTROY_REPLACE)
    e13:SetTarget(s.reptg)
    c:RegisterEffect(e13)
end

function s.repfilter(c)
    return c:IsType(TYPE_TOON)
end

function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:IsReason(REASON_BATTLE + REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
            and Duel.IsExistingMatchingCard(s.repfilter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler())
    end
    if Duel.SelectEffectYesNo(tp, c, 96) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESREPLACE)
        local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler())
        Duel.Destroy(g, REASON_EFFECT + REASON_REPLACE)
        return true
    else return false end
end

function s.atcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local bc = c:GetBattleTarget()
    return bc:IsType(TYPE_MONSTER) and c:CanChainAttack() and c:IsStatus(STATUS_OPPO_BATTLE)
end

function s.atop(e, tp, eg, ep, ev, re, r, rp)
    Duel.ChainAttack()
end

function s.disable(e, c)
    return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(), TYPE_EFFECT) == TYPE_EFFECT
end

function s.actcon(e)
    return Duel.GetAttacker() == e:GetHandler()
end

function s.efilter9(e, te)
    return te:GetHandler():IsSetCard(0xa50)
end

function s.atkval(e, c)
    local tp = e:GetHandler():GetControler()
    local g = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, 0, e:GetHandler(), TYPE_TOON)
    local atk = g:GetSum(Card.GetAttack)
    return math.ceil(atk)
end

function s.atlimit(e, c)
    return c:IsFaceup() and c:IsType(TYPE_TOON) and c ~= e:GetHandler()
end

function s.effectfilter(e, ct)
    local p = e:GetHandler():GetControler()
    local te, tp, loc = Duel.GetChainInfo(ct, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TRIGGERING_LOCATION)
    return p == tp and (te:GetHandler():IsCode(15259703) or te:GetHandler():IsCode(900000079) or te:GetHandler():IsCode(511001251)) and bit.band(loc, LOCATION_ONFIELD) ~= 0
end

function s.efilter(e, c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end

function s.aclimit(e, re, tp)
    return re:IsActiveType(TYPE_FIELD)
end

function s.ffilter(c, fc, sumtype, tp)
    return c:IsSetCard(0x62, fc, sumtype, tp) and c:IsType(TYPE_MONSTER, fc, sumtype, tp)
end

function s.srfilter(c)
    return (c:IsCode(15259703) or c:IsCode(900000079)) and c:IsAbleToHand()
end

function s.srtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.srfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.srop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.srfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end
