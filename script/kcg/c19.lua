-- 時械神 ラフィオン
local s, id = GetID()
function s.initial_effect(c)
    -- summon
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100000004, 0))
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SUMMON_PROC)
    e2:SetCondition(s.ntcon)
    c:RegisterEffect(e2)
    -- indes
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
    local e5 = e3:Clone()
    e5:SetCondition(s.damcon)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    c:RegisterEffect(e5)

    -- return hand
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(75797046, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DAMAGE_STEP_END)
    e1:SetCondition(s.con)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)

    -- to deck
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(100000004, 1))
    e8:SetCategory(CATEGORY_TODECK)
    e8:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e8:SetCountLimit(1)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(s.tdcon)
    e8:SetTarget(s.tdtg)
    e8:SetOperation(s.tdop)
    c:RegisterEffect(e8)

    -- sum limit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_MZONE)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTargetRange(1,0)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e15)
end

function s.ntcon(e, c, minc)
    if c == nil then
        return true
    end
    return minc == 0 and c:IsLevelAbove(5) and Duel.GetFieldGroupCount(c:GetControler(), LOCATION_MZONE, 0) == 0 and
               Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end
function s.damcon(e)
    return e:GetHandler():IsAttackPos()
end
function s.batop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local bc = c:GetBattleTarget()
    if bc then
        e:SetLabel(bc:GetAttack())
        e:SetLabelObject(bc)
    end
end
function s.con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local a = Duel.GetAttacker()
    if a == c then
        a = Duel.GetAttackTarget()
    end
    e:SetLabelObject(a)
    return a and a:IsType(TYPE_MONSTER) and a:IsRelateToBattle()
end
function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    local bc = e:GetHandler():GetBattleTarget()
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetLabelObject(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, bc:GetAttack())
end
function s.op(e, tp, eg, ep, ev, re, r, rp)
    local bc = e:GetHandler():GetBattleTarget()
    local atk = bc:GetAttack()
    if e:GetLabelObject():IsRelateToBattle() then
        Duel.SendtoHand(e:GetLabelObject(), nil, REASON_EFFECT)
    end
    if atk < 0 then
        atk = 0
    end
    Duel.Damage(1 - tp, atk, REASON_EFFECT)
end

function s.retcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler() == Duel.GetAttacker() or e:GetHandler() == Duel.GetAttackTarget()
end
function s.rettg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetAttackTarget() ~= nil
    end
    local bc = e:GetHandler():GetBattleTarget()
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, bc:GetAttack())
end
function s.retop(e, tp, eg, ep, ev, re, r, rp)
    local bc = e:GetHandler():GetBattleTarget()
    local atk = bc:GetAttack()
    if atk < 0 then
        atk = 0
    end
    Duel.Damage(1 - tp, atk, REASON_EFFECT)
end
function s.tdcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end
function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, e:GetHandler(), 1, 0, 0)
end
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
    end
end