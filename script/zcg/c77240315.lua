--究极体黑暗大邪神 索克(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --xyz summon
    Xyz.AddProcedure(c, nil, 12, 2)
    c:EnableReviveLimit()
    --SpecialSummon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.xyzcon)
    e1:SetOperation(s.xyzop)
    c:RegisterEffect(e1)
    --cannot target
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(s.disop)
    c:RegisterEffect(e3)
    --
    local e4 = Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE + CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(1040)
    e4:SetTarget(s.tg)
    e4:SetOperation(s.op)
    c:RegisterEffect(e4)
    --
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DISABLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0, LOCATION_ONFIELD)
    e5:SetTarget(s.distg)
    c:RegisterEffect(e5)
    --cannot direct attack
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e6:SetCondition(s.dircon)
    c:RegisterEffect(e6)
    --des
    local e7 = Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id, 1))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e7:SetCost(s.cost)
    e7:SetTarget(s.target)
    e7:SetOperation(s.operation)
    c:RegisterEffect(e7)
    --des
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id, 2))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e8:SetCost(s.cost)
    e8:SetTarget(s.target2)
    e8:SetOperation(s.operation2)
    c:RegisterEffect(e8)
    --Summon&&Activate
    local e9 = Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id, 3))
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e9:SetCost(s.cost)
    e9:SetTarget(s.target3)
    e9:SetOperation(s.operation3)
    c:RegisterEffect(e9)
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler(), TYPE_MONSTER) end
    local sg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, e:GetHandler(), TYPE_MONSTER)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, sg:GetCount(), 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, e:GetHandler(), TYPE_MONSTER)
    Duel.Destroy(sg, REASON_EFFECT)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil, TYPE_SPELL + TYPE_TRAP) end
    local sg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, TYPE_SPELL + TYPE_TRAP)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, sg:GetCount(), 0, 0)
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, TYPE_SPELL + TYPE_TRAP)
    Duel.Destroy(sg, REASON_EFFECT)
end

function s.dircon(e)
    return e:GetHandler():GetOverlayCount() ~= 0
end

function s.filter(c)
    return c:IsSetCard(0xa70)
end

function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
    local sg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, sg, sg:GetCount(), 0, 0)
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
    local sg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
    local dam = Duel.Remove(sg, POS_FACEUP, REASON_EFFECT)
    Duel.Damage(1 - tp, dam * 3000, REASON_EFFECT)
end

function s.distg(e, c)
    return c:IsSetCard(0xa70)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
    if re:GetHandler():IsSetCard(0xa70) then
        Duel.NegateEffect(ev)
    end
end

function s.hofilter(c, tp, xyzc)
    return c:IsCanBeXyzMaterial(xyzc) and c:IsSetCard(0x48)
end

function s.xyzcon(e, c)
    if c == nil then return true end
    local tp = c:GetControler()
    if Duel.GetLocationCount(tp, LOCATION_MZONE) < 0 then return false end
    return Duel.IsExistingMatchingCard(s.hofilter, tp, LOCATION_EXTRA, 0, 2, nil, tp, c)
end

function s.xyzop(e, tp, eg, ep, ev, re, r, rp, c)
    local tp = c:GetControler()
    Duel.PayLPCost(tp, 500)
    local mg = Duel.SelectMatchingCard(tp, s.hofilter, tp, LOCATION_EXTRA, 0, 2, 2, nil, tp, c)
    if mg:GetCount() < 0 then return end
    c:SetMaterial(mg)
    Duel.Overlay(c, mg)
end

function s.spfilter(c, e, tp)
    return (c:IsSetCard(0xa20) or c:IsSetCard(0xa201)) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP) and c:IsType(TYPE_MONSTER)
end

function s.acfilter(c)
    return (c:IsSetCard(0xa20) or c:IsSetCard(0xa201)) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:CheckActivateEffect(true, false, false) ~= nil
end

function s.target3(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return (Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, 1, nil, e, tp) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0) or (Duel.IsExistingMatchingCard(s.acfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, 1, nil) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0) end
end

function s.operation3(e, tp, eg, ep, ev, re, r, rp)
    local summon_g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, nil, e, tp)
    local ac_g = Duel.GetMatchingGroup(s.acfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, nil)
    local mt = Duel.GetLocationCount(tp, LOCATION_MZONE)
    local st = Duel.GetLocationCount(tp, LOCATION_SZONE)
    if #summon_g > 0 and mt > 0 then
        if Duel.IsPlayerAffectedByEffect(tp, 59822133) then mt = 1 end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, mt, mt, nil, e, tp)
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
    if #ac_g > 0 and st > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RESOLVECARD)
        local ag = Duel.SelectMatchingCard(tp, s.acfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, st, st, nil)
        local tc = ag:GetFirst()
        while tc do
            local tpe = tc:GetType()
            local te = tc:GetActivateEffect()
            local tg = te:GetTarget()
            local co = te:GetCost()
            local op = te:GetOperation()
            e:SetCategory(te:GetCategory())
            e:SetProperty(te:GetProperty())
            Duel.ClearTargetCard()
            Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
            Duel.Hint(HINT_CARD, 0, tc:GetOriginalCode())
            tc:CreateEffectRelation(te)
            if (tpe & TYPE_EQUIP + TYPE_CONTINUOUS + TYPE_FIELD) == 0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
                tc:CancelToGrave(false)
            end
            if te:GetCode() == EVENT_CHAINING then
                local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
                local tc = te2:GetHandler()
                local g = Group.FromCards(tc)
                local p = tc:GetControler()
                if co then co(te, tp, g, p, chain, te2, REASON_EFFECT, p, 1) end
                if tg then tg(te, tp, g, p, chain, te2, REASON_EFFECT, p, 1) end
            elseif te:GetCode() == EVENT_FREE_CHAIN then
                if co then co(te, tp, eg, ep, ev, re, r, rp, 1) end
                if tg then tg(te, tp, eg, ep, ev, re, r, rp, 1) end
            else
                local res, teg, tep, tev, tre, tr, trp = Duel.CheckEvent(te:GetCode(), true)
                if co then co(te, tp, teg, tep, tev, tre, tr, trp, 1) end
                if tg then tg(te, tp, teg, tep, tev, tre, tr, trp, 1) end
            end
            Duel.BreakEffect()
            local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
            if g then
                local etc = g:GetFirst()
                while etc do
                    etc:CreateEffectRelation(te)
                    etc = g:GetNext()
                end
            end
            tc:SetStatus(STATUS_ACTIVATED, true)
            if not tc:IsDisabled() then
                if te:GetCode() == EVENT_CHAINING then
                    local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
                    local tc = te2:GetHandler()
                    local g = Group.FromCards(tc)
                    local p = tc:GetControler()
                    if op then op(te, tp, g, p, chain, te2, REASON_EFFECT, p) end
                elseif te:GetCode() == EVENT_FREE_CHAIN then
                    if op then op(te, tp, eg, ep, ev, re, r, rp) end
                else
                    local res, teg, tep, tev, tre, tr, trp = Duel.CheckEvent(te:GetCode(), true)
                    if op then op(te, tp, teg, tep, tev, tre, tr, trp) end
                end
            else
            end
            Duel.RaiseEvent(Group.CreateGroup(tc), EVENT_CHAIN_SOLVED, te, 0, tp, tp, Duel.GetCurrentChain())
            if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
                Duel.Equip(tp, tc, g:GetFirst())
            end
            tc:ReleaseEffectRelation(te)
            if etc then
                etc = g:GetFirst()
                while etc do
                    etc:ReleaseEffectRelation(te)
                    etc = g:GetNext()
                end
            end
            tc = ag:GetNext()
        end
    end
end
