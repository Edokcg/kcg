-- Numeron Network
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e0 = Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41418852,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1) 
	e2:SetCost(s.NRTcost)
	e2:SetCondition(s.NNcondition)
	e2:SetTarget(s.NNtarget)
	e2:SetOperation(s.NNactivate)
	c:RegisterEffect(e2)

	local chain = Duel.GetCurrentChain
	copychain = 0
	Duel.GetCurrentChain = function()
		if copychain == 1 then
			copychain = 0
			return chain() - 1
		else
			return chain()
		end
	end

	-- local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(aux.Stringid(12744567,0))
	-- e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	-- e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	-- e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e4:SetRange(LOCATION_FZONE)
	-- e4:SetCondition(s.condition)
	-- e4:SetTarget(s.target)
	-- e4:SetOperation(s.operation)
	-- c:RegisterEffect(e4)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.con)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
s.listed_series={0x48,0x901,0x177,0x1178}

function s.cfilter(c)
	return c:GetFlagEffect(id)==0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA,0,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetCode(EFFECT_XYZ_MATERIAL)
		e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetRange(LOCATION_EXTRA)
		e01:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e01:SetValue(function(e,ec,rc,tp) return rc==tc end)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e01)
		local e02=e01:Clone()
		e02:SetCode(EFFECT_XYZ_LEVEL)
		e02:SetTarget(s.xyztg)
		e02:SetValue(function(e,mc,rc) return rc==tc and 4,mc:GetLevel() or mc:GetLevel() end)
		tc:RegisterEffect(e02)
		local e03=e02:Clone()
		e03:SetCode(EFFECT_XYZ_LEVEL)
		e03:SetTarget(s.xyztg)
		e03:SetValue(function(e,mc,rc) return rc==tc and 8,mc:GetLevel() or mc:GetLevel() end)
		tc:RegisterEffect(e03)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e4:SetOperation(s.op2)
		tc:RegisterEffect(e4)
	end
end
function s.xyztg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(1-tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	e:Reset()
end

function s.NNcondition(e, tp, eg, ep, ev, re, r, rp)
	return (Duel.GetMatchingGroupCount(nil, tp, LOCATION_MZONE + LOCATION_SZONE, 0, e:GetHandler()) == 0 and
			   Duel.GetTurnPlayer() == 1 - tp) or Duel.GetTurnPlayer() == tp
end
function s.NRTfilter2(c, e, tp, eg, ep, ev, re, r, rp, chain, chk)
	local te = c:GetActivateEffect()
	if not (c:IsSetCard(0x901) or c:IsSetCard(0x177) or c:IsSetCard(0x1178)) or not c:IsAbleToGraveAsCost() or not te then
		return
	end
	local condition = te:GetCondition()
	local cost = te:GetCost()
	local target = te:GetTarget()
	if te:GetCode() == EVENT_CHAINING then
		if chain <= 0 then
			return false
		end
		local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
		local tc = te2:GetHandler()
		local g = Group.FromCards(tc)
		local p = tc:GetControler()
		return (not condition or condition(e, tp, g, p, chain, te2, REASON_EFFECT, p)) and
				   (not cost or cost(e, tp, g, p, chain, te2, REASON_EFFECT, p, 0)) and
				   (not target or target(e, tp, g, p, chain, te2, REASON_EFFECT, p, 0))
	else
		-- if (te:GetCode()==EVENT_SPSUMMON or te:GetCode()==EVENT_SUMMON or te:GetCode()==EVENT_FLIP_SUMMON) and chk then copychain=1 end
		return (not condition or condition(e, tp, eg, ep, ev, re, r, rp)) and
				   (not cost or cost(e, tp, eg, ep, ev, re, r, rp, 0)) and
				   (not target or target(e, tp, eg, ep, ev, re, r, rp, 0))
		-- elseif te:GetCode()==e:GetCode() then
		--  if te:GetCode()==EVENT_SPSUMMON and chk then copychain=1 end
		--  return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
		--	and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
		-- else
		--  return false
	end
end
function s.NRTcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local chain = Duel.GetCurrentChain()
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.NRTfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp, eg, ep, ev, re, r,
				   rp, chain)
	end
	chain = Duel.GetCurrentChain() - 1
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.NRTfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp, eg, ep, ev, re, r,
				  rp, chain)
	if g:GetCount() > 0 then
		Duel.SendtoGrave(g, REASON_COST)
		g:KeepAlive()
		e:SetLabelObject(g)
	end
end
function s.NNtarget(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	-- not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local cg = e:GetLabelObject()
	if not cg then
		return false
	end
	local tc = cg:GetFirst()
	local chain = Duel.GetCurrentChain() - 1
	if tc == nil then
		return false
	end
	local te = tc:GetActivateEffect()
	if te == nil then
		return false
	end
	local tep = tc:GetControler()
	local cost = te:GetCost()
	Duel.ClearTargetCard()
	local tg = te:GetTarget()
	e:SetDescription(te:GetDescription())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	tc:CreateEffectRelation(te)
	if te:GetCode() == EVENT_CHAINING then
		local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
		local tc = te2:GetHandler()
		local g = Group.FromCards(tc)
		local p = tc:GetControler()
		if cost then
			cost(e, tp, g, p, chain, te2, REASON_EFFECT, p, 1)
		end
		if tg then
			tg(e, tp, g, p, chain, te2, REASON_EFFECT, p, 1)
		end
	else
		if cost then
			cost(e, tp, eg, ep, ev, re, r, rp, 1)
		end
		if tg then
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
		end
	end
	local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if gg then
		local etc = gg:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc = gg:GetNext()
		end
	end
end
function s.NNactivate(e, tp, eg, ep, ev, re, r, rp)
	local cg = e:GetLabelObject()
	if not cg then
		return
	end
	local tc = cg:GetFirst()
	local chain = Duel.GetCurrentChain() - 1
	copychain = 0
	if tc then
		local te = tc:GetActivateEffect()
		local op = te:GetOperation()
		if not op then
			cg:DeleteGroup()
			local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
			if gg then
				local etc = gg:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc = gg:GetNext()
				end
			end
			return
		end
		if te:GetCode() == EVENT_CHAINING then
			local te2 = Duel.GetChainInfo(chain, CHAININFO_TRIGGERING_EFFECT)
			local tc = te2:GetHandler()
			local g = Group.FromCards(tc)
			local p = tc:GetControler()
			if op then
				op(e, tp, g, p, chain, te2, REASON_EFFECT, p)
			end
		else
			if op then
				op(e, tp, eg, ep, ev, re, r, rp)
			end
		end
		local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
		if gg then
			local etc = gg:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc = gg:GetNext()
			end
		end
	end
	cg:DeleteGroup()
end

function s.cnofilters(c)
	local no=c.xyz_number
	return (no and no>=101 and no<=107 and c:IsSetCard(0x48))
	or c:IsCode(787,67926903)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.cnofilters,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED) and chkc:IsControler(tp) and s.cnofilters(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cnofilters,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.cxfilters, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.cnofilters,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil)
end
function s.cxfilters(c)
	return c:IsCode(787, 67926903) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local a = Duel.SelectMatchingCard(tp, s.cxfilters, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
		if a then Duel.Overlay(a,tc) end
	end
end