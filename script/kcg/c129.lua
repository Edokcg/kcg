-- 太阳神之翼神龙（AC）
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    
    -- special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- selfdes
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetCondition(s.descon)
    c:RegisterEffect(e2)

    -- spson
    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e11:SetCode(EFFECT_SPSUMMON_CONDITION)
    e11:SetValue(aux.FALSE)
    c:RegisterEffect(e11)

    -- 支付LP1000除外对方场上所有怪兽
    local e6 = Effect.CreateEffect(c)
    -- e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetDescription(aux.Stringid(10000011, 2))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(s.descost)
    e6:SetTarget(s.destg)
    e6:SetOperation(s.desop)
    c:RegisterEffect(e6)

    -- 解放怪兽增加攻击
    local e70 = Effect.CreateEffect(c)
    -- e70:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e70:SetDescription(aux.Stringid(10000011, 0))
    e70:SetCategory(CATEGORY_ATKCHANGE)
    e70:SetType(EFFECT_TYPE_IGNITION)
    e70:SetRange(LOCATION_MZONE)
    e70:SetCountLimit(1)
    e70:SetCost(s.otkcost2)
    e70:SetOperation(s.otkop2)
    c:RegisterEffect(e70)
end
s.listed_names = {27564031,10000010}

function s.spfilter(c)
    return c:IsCode(10000010) and c:IsAbleToGraveAsCost()
end
function s.spcon(e, c)
    if c == nil then
        return true
    end
    return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
               Duel.IsExistingMatchingCard(s.spfilter, c:GetControler(), LOCATION_HAND + LOCATION_DECK, 0, 1, nil) and
               Duel.IsExistingMatchingCard(Card.IsSetCard, c:GetControler(), LOCATION_GRAVE, 0, 3, nil, 0x23)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local tg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil)
    if #tg<1 then return end
    Duel.SendtoGrave(tg, REASON_COST)
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckLPCost(tp, 1000)
    end
    Duel.PayLPCost(tp, 1000)
end
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_MZONE, 1, nil)
    end
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(10000049)
    e1:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END)
    -- e:GetHandler():RegisterEffect(e1)
    local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
    Duel.Destroy(g, REASON_EFFECT)
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END)
    e:GetHandler():RegisterEffect(e1)
    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1, 0)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT + 0x1ff0000 + RESET_PHASE + PHASE_END)
    e:GetHandler():RegisterEffect(e2)
    local e3 = e2:Clone()
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(s.eefilter)
    e:GetHandler():RegisterEffect(e3)
end
function s.eefilter(e, te)
    return te:GetOwner() ~= e:GetOwner()
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.otkcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLP(tp) > 1
    end
    local lp = Duel.GetLP(tp)
    Duel.SetLP(tp, 1)
    e:SetLabel(lp - 1)
end
function s.otkcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return not c:IsType(TYPE_FUSION)
end
function s.otkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        c:RegisterFlagEffect(10000012, RESET_EVENT + 0x1ff0000, nil, 1)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT + 0x1ff0000)
        c:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end

function s.otkcost2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckReleaseGroup(tp, nil, 1, e:GetHandler())
    end
    local g = Duel.SelectReleaseGroup(tp, nil, 1, 99, e:GetHandler())
    local tc = g:GetFirst()
    local tatk = 0
    local tdef = 0
    while tc do
        local atk = tc:GetAttack()
        local def = tc:GetDefense()
        if atk < 0 then
            atk = 0
        end
        if def < 0 then
            def = 0
        end
        tatk = tatk + atk
        tdef = tdef + def
        tc = g:GetNext()
    end
    e:SetLabelObject({tatk,tdef})
    Duel.Release(g, REASON_COST)
end
function s.otkop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tatk=e:GetLabelObject()[1]
    local tdef=e:GetLabelObject()[2]
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tatk)
        e1:SetReset(RESET_EVENT + 0x1fe0000)
        c:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(tdef)
        c:RegisterEffect(e2)
    end
end

function s.efilter(e, te)
    local c = e:GetHandler()
    local tc = te:GetOwner()
    if tc == e:GetOwner() or te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) then
        return false
    else
        return te:GetActiveType() == TYPE_TRAP
    end
end

function s.sdcon2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = re:GetHandler()
    local eff=0
    for i = 1, 522 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if tc~=c and te:GetOwner()==tc and (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP) and te:GetHandler()==c and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE)
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then 
                    eff=1
                    break 
                end
            end
        end
    end
    return eff==1
end
function s.sdop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = re:GetHandler()
    local eff=0
    for i = 1, 522 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if tc~=c and te:GetOwner()==tc and (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP) and te:GetHandler()==c and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE)
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then 
                    eff=te
                    break 
                end
            end
        end
    end
    if eff==0 then return end
    local e83 = Effect.CreateEffect(c)
    e83:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e83:SetRange(LOCATION_MZONE)
    e83:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e83:SetCountLimit(1)
    e83:SetCode(EVENT_PHASE + PHASE_END)
    e83:SetLabelObject(eff)
    e83:SetOperation(s.setop2)
    e83:SetReset(RESET_PHASE + PHASE_END)
    c:RegisterEffect(e83) 
end
function s.setop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local te = e:GetLabelObject()
    if not te or te==0 then return end
    te:Reset()
end   

function s.reop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    for i = 1, 430 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if te:GetOwner() ~= e:GetOwner() 
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then
                    if te:GetType() == EFFECT_TYPE_FIELD then
                        local e80 = Effect.CreateEffect(c)
                        e80:SetType(EFFECT_TYPE_SINGLE)
                        e80:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
                        e80:SetRange(LOCATION_MZONE)
                        e80:SetCode(EFFECT_IMMUNE_EFFECT)
                        e80:SetValue(function(e, te2)
                            return te2 == te
                        end)
                        e80:SetReset(RESET_EVENT + 0x1fe0000)
                        c:RegisterEffect(e80)
                    elseif (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP or te:GetType()==EFFECT_TYPE_GRANT or te:GetType()==EFFECT_TYPE_XMATERIAL)
					and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
                    and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
                        te:Reset()
                    end
                end
            end
        end
    end
    for i = 2000, 2030 do
        if c:IsHasEffect(i) then
            local ae = {c:IsHasEffect(i)}
            for _, te in ipairs(ae) do
                if te:GetOwner() ~= e:GetOwner() 
                and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER)) then
                    if te:GetType() == EFFECT_TYPE_FIELD then
                        local e80 = Effect.CreateEffect(c)
                        e80:SetType(EFFECT_TYPE_SINGLE)
                        e80:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
                        e80:SetRange(LOCATION_MZONE)
                        e80:SetCode(EFFECT_IMMUNE_EFFECT)
                        e80:SetValue(function(e, te2)
                            return te2 == te
                        end)
                        e80:SetReset(RESET_EVENT + 0x1fe0000)
                        c:RegisterEffect(e80)
                    elseif (te:GetType()==EFFECT_TYPE_SINGLE or te:GetType()==EFFECT_TYPE_EQUIP or te:GetType()==EFFECT_TYPE_GRANT or te:GetType()==EFFECT_TYPE_XMATERIAL)
					and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
                    and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
                        te:Reset()
                    end
                end
            end
        end
    end
end

function s.atcon(e)
    return bit.band(e:GetHandler():GetSummonType(), SUMMON_TYPE_SPECIAL) == SUMMON_TYPE_SPECIAL
end

function s.atlimit(e, c)
    return c ~= e:GetHandler()
end

function s.tgvalue(e, re, rp)
    return rp ~= e:GetHandlerPlayer() and re:GetHandler():GetTurnID() ~= Duel.GetTurnCount()
end

function s.lffilter(e, re, rp)
    return re:GetOwner() ~= e:GetHandler()
end