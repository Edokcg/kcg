--奥利哈刚 奇达拉(ZCG)
local s, id = GetID()
function s.initial_effect(c)
	--special summon
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--indes
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(s.rdcon)
	e2:SetOperation(s.rdop)
	c:RegisterEffect(e2)
	--spsummon
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98710393, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check = true
		s[0] = 0
		s[1] = 0
		local ge1 = Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1, 0)
	end
end

function s.checkop(e, tp, eg, ep, ev, re, r, rp)
	if bit.band(r, REASON_BATTLE) == 0 and Duel.GetAttacker() ~= nil and Duel.GetAttackTarget() ~= nil then
		s[ep] = s[ep] + ev
	end
end

function s.rdcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetAttacker() ~= nil and Duel.GetAttackTarget() ~= nil
end

function s.rdop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetAttacker() ~= nil and Duel.GetAttackTarget() ~= nil then
		Duel.ChangeBattleDamage(tp, 0)
	end
end

function s.spcon1(e, c)
	if c == nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
		Duel.CheckLPCost(c:GetControler(), 500)
end

function s.spop1(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.PayLPCost(tp, 500)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.spfilter(c, e, tp)
	return c:IsCode(7634581) and c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE, 0, 1, nil, e,
				tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e,
		tp)
	local tc = g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc, 0, tp, tp, true, true, POS_FACEUP)
		local e1 = Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(s[tp])
		e1:SetReset(RESET_EVENT + 0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
