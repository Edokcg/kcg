-- 奥利哈钢第二结界（K）
local s, id = GetID()
function s.initial_effect(c)
	-- 发动效果
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.atcon)
	e1:SetTarget(s.actg)
	c:RegisterEffect(e1)

	local e000 = Effect.CreateEffect(c)
	e000:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SINGLE_RANGE)
	e000:SetType(EFFECT_TYPE_SINGLE)
	e000:SetRange(LOCATION_SZONE)
	e000:SetCode(EFFECT_ULTIMATE_IMMUNE)
	c:RegisterEffect(e000)

	-- 不会被卡的效果破坏、除外、返回手牌和卡组
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(s.efilterr)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
	local e6 = e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	local e7 = e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e7)
	local e104 = e4:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105 = e4:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106 = e4:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107 = e4:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108 = e4:Clone()
	e108:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e108)
	local e109 = e4:Clone()
	e109:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e109)
	local e111 = e4:Clone()
	e111:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e111)

	-- 生命值回复
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13715, 13))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	-- local e02 = e2:Clone()
	-- e02:SetRange(LOCATION_GRAVE)
	-- e02:SetCondition(s.speccon)
	-- c:RegisterEffect(e02)  

	-- 解放自己怪兽破坏攻击怪兽
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13715, 12))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	-- local e03 = e3:Clone()
	-- e03:SetRange(LOCATION_GRAVE)
	-- e03:SetCondition(s.speccon2)
	-- c:RegisterEffect(e03)  

	-- selfdes
	local e17 = Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e17:SetRange(LOCATION_SZONE)
	e17:SetCode(EFFECT_SELF_DESTROY)
	e17:SetCondition(s.descon)
	c:RegisterEffect(e17)

	-- 复制第一结界效果
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	-- e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e4:SetCode(EVENT_ADJUST)
	-- e4:SetRange(LOCATION_SZONE)
	-- e4:SetCondition(s.sdcon2)
	-- e4:SetOperation(s.sdop)
	-- c:RegisterEffect(e4)
	-- local e04=e4:Clone()
	-- e04:SetRange(LOCATION_GRAVE)  
	-- e04:SetCondition(s.speccon3) 
	-- c:RegisterEffect(e04)
end
s.listed_names={10}
s.listed_series={0x900}

function s.efilterr(e, te)
	return te and not (te:GetOwner()==e:GetOwner() or te:GetOwner():IsSetCard(0x900))
end

-- function s.specfilter(c)
-- 	return c:IsFaceup() and c:IsCode(574) and not c:IsDisabled()
-- end
-- function s.speccon(e)
-- 	return Duel.IsExistingMatchingCard(s.specfilter, e:GetHandlerPlayer(), LOCATION_GRAVE, 0, 1, nil)
-- end

function s.atcon(e)
	local tc = Duel.GetFieldCard(e:GetHandler():GetControler(), LOCATION_SZONE, 5)
	local tc2 = Duel.GetFieldCard(1 - e:GetHandler():GetControler(), LOCATION_SZONE, 5)
	return (tc ~= nil and tc:IsFaceup() and tc:IsCode(10)) or
			   (tc2 ~= nil and tc2:IsFaceup() and tc2:IsCode(10))
end
function s.actg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	Duel.SetChainLimit(aux.FALSE)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) > 0
	end
	Duel.SetTargetPlayer(tp)
	local rec = (Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0)) * 500
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, rec)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local rec = (Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0)) * 500
	local p = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER)
	Duel.Recover(p, rec, REASON_EFFECT)
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return tp ~= Duel.GetTurnPlayer()
end
-- function s.speccon2(e, tp, eg, ep, ev, re, r, rp)
-- 	return tp ~= Duel.GetTurnPlayer() and
-- 			   Duel.IsExistingMatchingCard(s.specfilter, e:GetHandlerPlayer(), LOCATION_GRAVE, 0, 1, nil)
-- end
function s.rfilter(c)
	return c:IsReleasableByEffect()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.rfilter, tp, LOCATION_MZONE, 0, 1, nil)
	end
	local g = Duel.SelectMatchingCard(tp, s.rfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	if #g<1 then return end
	Duel.Release(g, REASON_COST)
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
	local tg = Duel.GetAttacker()
	if chk == 0 then
		return tg:IsOnField() and tg:IsDestructable()
	end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, tg, 1, 0, 0)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetAttacker()
	if tc:CanAttack() and Duel.NegateAttack() then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end

function s.sdcon2(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetFlagEffect(111) == 0
end
function s.speccon3(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetFlagEffect(111) == 0 and
			   Duel.IsExistingMatchingCard(s.specfilter, e:GetHandlerPlayer(), LOCATION_GRAVE, 0, 1, nil)
end
function s.sdop(e, tp, eg, ep, ev, re, r, rp)
	e:GetHandler():CopyEffect(10, 0)
	e:GetHandler():RegisterFlagEffect(111, RESET_EVENT + RESETS_STANDARD, 0, 1)
end

function s.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end
function s.descon(e)
	local c = e:GetHandler()
	return not Duel.IsExistingMatchingCard(s.damfilter, 0, LOCATION_SZONE, LOCATION_SZONE, 1, nil)
end
