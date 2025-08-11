-- 無限械アイン・ソフ
local s,id=GetID()
function s.initial_effect(c)
	-- Activate to Grave
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, TIMING_END_PHASE)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetTarget(s.reptg)
	c:RegisterEffect(e9)  
	
	-- special summon
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condition2)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation2)
	c:RegisterEffect(e4)

	-- to Grave
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1, 0, EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(s.condition1)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)

	--to deck
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,3))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1, 0, EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(s.condition1)
	e8:SetTarget(s.tdtg)
	e8:SetOperation(s.tdop)
	c:RegisterEffect(e8)

	-- local e5 = Effect.CreateEffect(c)
	-- e5:SetDescription(aux.Stringid(100000013, 2))
	-- e5:SetCategory(CATEGORY_TOHAND)
	-- e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	-- e5:SetCode(EVENT_TO_GRAVE)
	-- e5:SetCondition(s.condition3)
	-- e5:SetTarget(s.target5)
	-- e5:SetOperation(s.operation3)
	-- c:RegisterEffect(e5)

	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE, 0)
	e6:SetValue(0)
	c:RegisterEffect(e6)

	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(id)
	e10:SetTargetRange(1, 0)
	e10:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e10)   

	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		s[2]={}
		s[3]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end)
    local ge4=Effect.CreateEffect(c)
    ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge4:SetCode(EVENT_ADJUST)
    ge4:SetRange(LOCATION_SZONE)
    ge4:SetCondition(s.con)
    ge4:SetOperation(s.op)
    c:RegisterEffect(ge4)
end
s.listed_series = {0x4a}
s.listed_names = {9409625,72883039}

function s.valcon(e,re,r,rp)
	return (r&REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp and e:GetHandler():GetFlagEffect(id+1)==0 end
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	return true
end

function s.costfilter(c)
	return c:IsFaceup() and c:IsCode(9409625) and c:IsAbleToGraveAsCost()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_SZONE, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_SZONE, 0, 1, 1, nil)
	if #g<1 then return end
	Duel.SendtoGrave(g, REASON_COST)
end

function s.condition2(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsTurnPlayer(tp)
end
function s.filter(c, e, sp)
	return c:IsSetCard(0x4a) and c:GetLevel()==10 and c:IsCanBeSpecialSummoned(e, 0, sp, false, false)
end
function s.target4(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, tp, LOCATION_HAND)
end
function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local ct = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then
		ct = 1
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local gs = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND, 0, 1, ct, nil, e, tp)
	if gs:GetCount() > 0 then
		Duel.SpecialSummon(gs, 0, tp, tp, false, false, POS_FACEUP)
	end
end

function s.condition1(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.rfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.rfilter, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end
function s.operation1(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local cg = Duel.SelectMatchingCard(tp, s.rfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	if cg:GetCount() == 0 then
		return
	end
	Duel.SendtoGrave(cg, REASON_EFFECT + REASON_DISCARD)
	Duel.BreakEffect()
	Duel.Draw(tp, 2, REASON_EFFECT)
end

function s.tdfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc)
	end
	if chk == 0 then
		return Duel.IsExistingTarget(s.tdfilter, tp, LOCATION_GRAVE, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
end
function s.setfilter(c)
	return c:IsCode(72883039) and c:IsSSetable()
end
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc, nil, 2, REASON_EFFECT) ~= 0 then
		local g = Duel.GetMatchingGroup(s.setfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(36894320, 2)) then
			local sc = g:Select(tp, 1, 1, nil):GetFirst()
			Duel.SSet(tp, sc)
		end
	end
end

function s.cfilter(c,tp)
	return c:IsSetCard(0x4a) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(s.cfilter,nil,tp)
	local g2=eg:Filter(s.cfilter,nil,1-tp)
	local tc1=g1:GetFirst()
	while tc1 do
		if s[tp]==0 then
			s[2+tp][1]=tc1:GetCode()
			s[tp]=s[tp]+1
		else
			local chk=true
			for i=1,s[tp]+1 do
				if s[2+tp][i]==tc1:GetCode() then
					chk=false
				end
			end
			if chk then
				s[2+tp][s[tp]+1]=tc1:GetCode()
				s[tp]=s[tp]+1
			end
		end
		tc1=g1:GetNext()
	end
	while tc2 do
		if s[1-tp]==0 then
			s[2+1-tp][1]=tc2:GetCode()
			s[1-tp]=s[1-tp]+1
		else
			local chk=true
			for i=1,s[1-tp]+1 do
				if s[2+1-tp][i]==tc2:GetCode() then
					chk=false
				end
			end
			if chk then
				s[2+1-tp][s[1-tp]+1]=tc2:GetCode()
				s[1-tp]=s[1-tp]+1
			end
		end
		tc2=g2:GetNext()
	end
end

function s.con(e, tp, eg, ep, ev, re, r, rp)
	for i = 0, 1 do
		return Duel.IsPlayerAffectedByEffect(i, EFFECT_CANNOT_SPECIAL_SUMMON) 
		or Duel.IsPlayerAffectedByEffect(i, EFFECT_CANNOT_SUMMON)
		or Duel.IsPlayerAffectedByEffect(i, EFFECT_CANNOT_FLIP_SUMMON)
	end
end
function s.op(e, tp, eg, ep, ev, re, r, rp)
	for i = 0, 1 do
		local effs = {Duel.GetPlayerEffect(i, EFFECT_CANNOT_SPECIAL_SUMMON)}
		for _, eff in ipairs(effs) do
			if eff:GetOwner():IsSetCard(0x4a) and eff:GetLabel()~=id then
				local target=eff:GetCondition()
				eff:SetCondition(function(...) 
					return (not target or target(...)) and not Duel.GetPlayerEffect(i,id) end)
				eff:SetLabel(id)
			end
		end
		local effs2 = {Duel.GetPlayerEffect(i, EFFECT_CANNOT_SUMMON)}
		for _, eff in ipairs(effs2) do
			if eff:GetOwner():IsSetCard(0x4a) and eff:GetLabel()~=id then
				local target=eff:GetCondition()
				eff:SetCondition(function(...) 
					return (not target or target(...)) and not Duel.GetPlayerEffect(i,id) end)
				eff:SetLabel(id)
			end
		end 
		local effs3 = {Duel.GetPlayerEffect(i, EFFECT_CANNOT_FLIP_SUMMON)}
		for _, eff in ipairs(effs3) do
			if eff:GetOwner():IsSetCard(0x4a) and eff:GetLabel()~=id then
				local target=eff:GetCondition()
				eff:SetCondition(function(...) 
					return (not target or target(...)) and not Duel.GetPlayerEffect(i,id) end)
				eff:SetLabel(id)
			end
		end		  
	end
end