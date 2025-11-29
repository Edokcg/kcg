-- 召喚時計 (K)
local s,id=GetID()
function s.initial_effect(c)
	-- turn count
	local ge = Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_TURN_END)
	ge:SetCondition(s.regcon)
	ge:SetOperation(s.regop)
	Duel.RegisterEffect(ge, 0)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123709,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.rfilter(tc)
    local c1,c2=tc:GetTributeRequirement()
    local eff1 = {tc:GetCardEffect(EFFECT_LIMIT_SUMMON_PROC)}
    local eff2 = {tc:GetCardEffect(EFFECT_LIMIT_SET_PROC)}
    local eff12 = {}
	local eff22 = {}
    for _, te in ipairs(eff1) do
        local e1 = te:Clone()
        table.insert(eff12, e1)
        local e2 = te:Clone()
        e2:SetCode(EFFECT_SUMMON_PROC)
        tc:RegisterEffect(e2)
        table.insert(eff22, e2)
        te:Reset()
    end
    for _, te in ipairs(eff2) do
        local e1 = te:Clone()
        table.insert(eff12, e1)
        local e2 = te:Clone()
        e2:SetCode(EFFECT_SET_PROC)
        tc:RegisterEffect(e2)
        table.insert(eff22, e2)
        te:Reset()
    end
	local e2 = Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetValue(c1)
	tc:RegisterEffect(e2, true)
    table.insert(eff22, e2)
	local e3 = e2:Clone()
	e3:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
	tc:RegisterEffect(e3, true)
    table.insert(eff22, e3)
	if not (tc:IsType(TYPE_MONSTER) and (tc:IsSummonable(true, nil) or tc:IsMSetable(true, nil))) then
        for _, te in ipairs(eff22) do
            te:Reset()
        end
        for _, te in ipairs(eff12) do
            tc:RegisterEffect(te)
        end
		return false
	end
    for _, te in ipairs(eff22) do
        te:Reset()
    end
    for _, te in ipairs(eff12) do
        tc:RegisterEffect(te)
    end
	return true
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect, tp, LOCATION_MZONE, 0, 1, nil) 
        and e:GetHandler():IsReleasableByEffect()
	end
	local g = Duel.SelectMatchingCard(tp, Card.IsReleasableByEffect, tp, LOCATION_MZONE, 0, 1, 1, nil)
	if #g<1 then return end
	g:AddCard(e:GetHandler())
	e:SetLabel(e:GetHandler():GetFlagEffectLabel(120))
	Duel.Release(g, REASON_COST)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return re and not re:IsActiveType(TYPE_MONSTER) and rp == 1 - tp
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local ct = c:GetFlagEffectLabel(120)
	if not ct then
		ct = 0
	end
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.rfilter, tp, LOCATION_HAND, 0, 1, nil) and ct > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 0, 0, LOCATION_HAND)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = e:GetLabel()
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if ft < 1 or not Duel.IsExistingMatchingCard(s.rfilter, tp, LOCATION_HAND, 0, 1, nil) or ct < 1 then
		return
	end
	local fft = math.min(ct, ft)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SUMMON)
	local g = Duel.SelectMatchingCard(tp, s.rfilter, tp, LOCATION_HAND, 0, 1, fft, nil)
	if g:GetCount() == 0 then
		return
	end
	local tc = g:GetFirst()
	while tc do
		local c1,c2=tc:GetTributeRequirement()
		local eff1 = {tc:GetCardEffect(EFFECT_LIMIT_SUMMON_PROC)}
		local eff2 = {tc:GetCardEffect(EFFECT_LIMIT_SET_PROC)}
		local eff12 = {}
        local eff22 = {}
		for _, te in ipairs(eff1) do
			local e1 = te:Clone()
			table.insert(eff12, e1)
			local e2 = te:Clone()
            e2:SetCode(EFFECT_SUMMON_PROC)
			tc:RegisterEffect(e2)
			table.insert(eff22, e2)
			te:Reset()
		end
		for _, te in ipairs(eff2) do
			local e1 = te:Clone()
			table.insert(eff12, e1)
			local e2 = te:Clone()
            e2:SetCode(EFFECT_SET_PROC)
			tc:RegisterEffect(e2)
			table.insert(eff22, e2)
			te:Reset()
		end
		local e2 = Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DECREASE_TRIBUTE)
		e2:SetValue(c1)
		e2:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e2, true)
        table.insert(eff22, e2)
		local e3 = e2:Clone()
		e3:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
		tc:RegisterEffect(e3, true)
        table.insert(eff22, e3)
		local s2 = tc:IsSummonable(true, nil)
		local s3 = tc:IsMSetable(true, nil)
		if (s2 and s3 and Duel.SelectPosition(tp, tc, POS_FACEUP_ATTACK + POS_FACEDOWN_DEFENSE) == POS_FACEUP_ATTACK) or
			not s3 then
			Duel.Summon(tp, tc, true, nil, 0)
		else
			Duel.MSet(tp, tc, true, nil, 0)
		end
        for _, te in ipairs(eff22) do
            te:Reset()
        end
		for _, te in ipairs(eff12) do
			tc:RegisterEffect(te)
		end
		tc = g:GetNext()
	end
end

function s.regcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return Duel.GetTurnPlayer() == tp and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function s.regop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = c:GetFlagEffectLabel(120)
	if not ct then
		c:RegisterFlagEffect(120, RESET_EVENT + EVENT_LEAVE_FIELD, 0, 1, 1)
	else
		c:SetFlagEffectLabel(120, ct + 1)
	end
end
