-- Number C1000: Numerronius the Divine Giant
local s, id = GetID()
function s.initial_effect(c)
    -- xyz summon
    Xyz.AddProcedure(c,nil,12,5,s.ovfilter,aux.Stringid(id,7))
    c:EnableReviveLimit()

    -- cannot destroyed
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e0:SetValue(s.indes)
    c:RegisterEffect(e0)

    -- cannot special summon
    local e01 = Effect.CreateEffect(c)
    e01:SetType(EFFECT_TYPE_SINGLE)
    e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e01:SetCode(EFFECT_SPSUMMON_CONDITION)
    e01:SetValue(s.splimit)
    -- c:RegisterEffect(e01)

    -- Negate Effects
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(0, LOCATION_MZONE)
    e1:SetTarget(s.actfilter)
    c:RegisterEffect(e1)
    local e10 = e1:Clone()
    e10:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e10)

    -- Block Attacks
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetTargetRange(0, LOCATION_MZONE)
    e2:SetTarget(s.actfilter)
    c:RegisterEffect(e2)

    -- Destroy at End of Battle Phase, and Special Summon Destroyed monsters
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(13715, 0))
    e3:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCode(EVENT_PHASE + PHASE_BATTLE)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)

    -- Destroy a Monster
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(1639384, 0))
    e4:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0, TIMING_END_PHASE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(Cost.DetachFromSelf(1))
    e4:SetTarget(s.target)
    e4:SetOperation(s.operation)
    c:RegisterEffect(e4)

    -- Destroy replace
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(s.desreptg)
    e5:SetOperation(s.desrepop)
    c:RegisterEffect(e5)
end
s.xyz_number = 1000
s.listed_series = {0x48, 0x1048, 0x1073}
s.listed_names = {586}

function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(586) and Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.indes(e, c)
    return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) and
               not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and
               not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.splimit(e, se, sp, st)
    return se and se:GetHandler():IsSetCard(0x14b)
end

function s.desfilter(c)
    return c:IsFaceup() and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
    local c = e:GetHandler()
    return Duel.IsExistingMatchingCard(s.desfilter, c:GetControler(), 0, LOCATION_MZONE, 1, c)
end

function s.actfilter(e, c)
    return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end

function s.filter(c, e, tp, tid)
    return c:GetTurnID() == tid and c:IsCanBeSpecialSummoned(e, 0, tp, true, true) and c:IsType(TYPE_MONSTER) and
               bit.band(c:GetReason(), REASON_DESTROY) ~= 0 and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(Card.IsDestructable, tp, 0, LOCATION_MZONE, 1, nil)
    end
    local sg = Duel.GetMatchingGroup(Card.IsDestructable, tp, 0, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, sg:GetCount(), 0, 0)
end
function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(Card.IsDestructable, tp, 0, LOCATION_MZONE, nil)
    if Duel.Destroy(sg, REASON_EFFECT) > 0 then
        Duel.BreakEffect()
        local ft1 = Duel.GetLocationCount(tp, LOCATION_MZONE)
        if ft1 <= 0 then
            return
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_GRAVE, LOCATION_GRAVE, ft1, ft1, nil, e, tp,
                      Duel.GetTurnCount())
        if g:GetCount() > 0 then
            Duel.SpecialSummon(g, 0, tp, tp, true, true, POS_FACEUP_DEFENSE)
        end
    end
end

function s.filter2(c, e)
    local tpp = c:GetControler()
    return c:IsDestructable()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
    end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and s.filter2(chkc, e) and chkc~=e:GetHandler()
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler(), e)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, e:GetHandler(), e)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, 0, 0)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    local ttp = tc:GetControler()
    if tc and tc:IsRelateToEffect(e) then
        if Duel.Destroy(tc, REASON_EFFECT) > 0 then
            Duel.BreakEffect()
            if Duel.IsExistingMatchingCard(s.filter3, ttp, LOCATION_EXTRA, 0, 1, nil, e, ttp, tc) then
                local g2 = Duel.GetFieldGroup(ttp, LOCATION_EXTRA, 0)
                if tp ~= ttp then
                    Duel.ConfirmCards(tp, g2)
                end
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                local g = Duel.SelectMatchingCard(tp, s.filter3, ttp, LOCATION_EXTRA, 0, 1, 1, nil, e, ttp)
                if g:GetCount() > 0 then
                    Duel.SpecialSummon(g, 0, tp, ttp, true, false, POS_FACEUP)
                end
            end
        end
    end
end
function s.filter3(c, e, tp)
	return (c:IsSetCard(0x1048) or c:IsSetCard(0x1073)) 
	and c:IsCanBeSpecialSummoned(e, 0, tp, true, false) 
	and Duel.GetLocationCountFromEx(tp,tp,nil,c) > 0
end

function s.repfilter(c)
    return not c:IsStatus(STATUS_DESTROY_CONFIRMED + STATUS_BATTLE_DESTROYED)
end
function s.desreptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local ttp = c:GetControler()
    if chk == 0 then
        return c:IsOnField() and c:IsFaceup() and not c:IsReason(REASON_REPLACE) and
                   Duel.IsExistingMatchingCard(s.repfilter, ttp, LOCATION_MZONE, 0, 1, c)
    end
    if Duel.SelectYesNo(ttp, aux.Stringid(13715, 1)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESREPLACE)
        local g = Duel.SelectMatchingCard(ttp, s.repfilter, ttp, LOCATION_MZONE, 0, 1, 1, c)
        if #g<1 then return false end
        e:SetLabelObject(g:GetFirst())
        Duel.HintSelection(g)
        g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED, true)
        return true
    else
        return false
    end
end
function s.desrepop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetLabelObject()
    tc:SetStatus(STATUS_DESTROY_CONFIRMED, false)
    Duel.Destroy(tc, REASON_EFFECT + REASON_REPLACE)
end

function s.afilter(c)
    return c:IsFaceup() and c:IsCode(41418852)
end
