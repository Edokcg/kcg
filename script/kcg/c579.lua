-- 欧贝利斯克之巨神兵
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,1,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(2)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()

	-- cannot special summon
	local e0 = Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)

	-- 特殊召唤方式
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 解放2只怪破坏对方场上怪兽
	local e4 = Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetDescription(aux.Stringid(10000000, 1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(s.descost)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)

	local e22 = Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e22:SetRange(LOCATION_MZONE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetCountLimit(1)
	e22:SetCode(EVENT_PHASE + PHASE_END)
	e22:SetCondition(s.ocon2)
	e22:SetOperation(s.ermop)
	c:RegisterEffect(e22)
end

function s.ofilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end

function s.ocon2(e)
	return not Duel.IsExistingMatchingCard(s.ofilter2, e:GetHandlerPlayer(), LOCATION_SZONE, LOCATION_SZONE, 1, nil)
end
function s.ermop(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_RULE+REASON_EFFECT)
end
------------------------------------------------------------------------
function s.spmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
-----------------------------------------------------------
function s.spcon(e, c)
	if c == nil then
		return true
	end
	local tp = c:GetControler()
	local a = Duel.GetMatchingGroupCount(s.spmfilter, tp, LOCATION_MZONE, 0, nil)
	return a >= 3 and (Duel.GetLocationCount(tp, LOCATION_MZONE)>=-3)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<-3 then return end
	local g = Duel.SelectMatchingCard(c:GetControler(), s.spmfilter, c:GetControler(), LOCATION_ONFIELD, 0, 3, 3, nil)
	if #g<1 then return end
	Duel.Release(g, REASON_COST)
end

-------------------------------------------------------------------------------------------------------------------
function s.ofilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end

function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.CheckReleaseGroup(tp, s.ofilter, 2, e:GetHandler())
	end
	local g = Duel.SelectReleaseGroup(tp, s.ofilter, 2, 2, e:GetHandler())
	Duel.Release(g, REASON_COST)
end

function s.filter(c, atk)
	return ((c:IsPosition(POS_FACEUP_ATTACK) and c:GetAttack() < atk) or
			   (c:IsPosition(POS_FACEUP_DEFENSE) and c:GetDefense() < atk) or c:IsFacedown())
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local atk = c:GetAttack()
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil, atk)
	end
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil, atk)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local atk = c:GetAttack()
	local g = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_MZONE, nil, atk)
	Duel.Hint(HINT_ANIME, tp, aux.Stringid(828, 0))
	Duel.Destroy(g, REASON_RULE+REASON_EFFECT)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END)
	c:RegisterEffect(e1)
end