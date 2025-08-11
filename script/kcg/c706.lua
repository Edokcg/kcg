-- アストログラフ・マジシャン (Anime)
local s, id = GetID()
function s.initial_effect(c)
	-- Special Summon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- Special Summon Supreme King Z-Arc
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.zarccost)
	e2:SetTarget(s.zarctg)
	e2:SetOperation(s.zarcop)
	c:RegisterEffect(e2)
end
s.listed_series = {0x2073, 0x2017, 0x1046}
s.listed_names = {53}

local ZARC_LOC = LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND + LOCATION_EXTRA + LOCATION_DECK

function s.spcfilter(c, e, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) 
	-- and c:IsCanBeEffectTarget(e) 
	-- and (c:IsLocation(LOCATION_SZONE + LOCATION_GRAVE + LOCATION_MZONE) 
	--     or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())
	--     or c:IsLocation(LOCATION_HAND + LOCATION_DECK) 
	-- 	or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return eg:IsExists(s.spcfilter, 1, nil, e, tp) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
				   c:IsCanBeSpecialSummoned(e, 1, tp, false, false)
	end
	local g = eg:Filter(s.spcfilter, nil, e, tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, g, #g, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spcfilterchk(c, tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) 
	and (c:IsLocation(LOCATION_SZONE + LOCATION_GRAVE + LOCATION_MZONE) or
		(c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) 
	or (c:IsLocation(LOCATION_HAND + LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) )
	and not Duel.GetFieldCard(tp, c:GetPreviousLocation(), c:GetPreviousSequence())
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g = Duel.GetTargetCards(e)
	if Duel.SpecialSummon(c, 1, tp, tp, false, false, POS_FACEUP) > 0 and #g > 0 and Duel.SelectEffectYesNo(tp, c) then
		g:KeepAlive()
		-- spsummon
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM + id)
		e1:SetLabelObject(g)
		e1:SetTarget(s.rettg)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.RaiseSingleEvent(c, EVENT_CUSTOM + id, e, r, tp, tp, 0)
	end
end

function s.rettg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	local g = e:GetLabelObject()
	Duel.SetTargetCard(g)
	g:DeleteGroup()
end
function s.retop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetTargetCards(e):Filter(s.spcfilterchk, nil, tp)
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetValue(0xffffff)
	Duel.RegisterEffect(e1, tp)
	for tc in aux.Next(g) do
		if tc:IsPreviousLocation(LOCATION_PZONE) then
			local seq = 0
			if tc:GetPreviousSequence() == 7 or tc:GetPreviousSequence() == 4 then
				seq = 1
			end
			Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, tc:GetPreviousPosition(), true, (1 << seq))
		else
			Duel.MoveToField(tc, tp, tp, tc:GetPreviousLocation(), tc:GetPreviousPosition(), true,
				(1 << tc:GetPreviousSequence()))
		end
	end
	e1:Reset()
	if not e:GetHandler():IsOriginalCode(48) and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		local type = e:GetHandler():GetOriginalType()|TYPE_PENDULUM
		if bit.band(type,TYPE_TOKEN)~=0 then type = type - TYPE_TOKEN end
		e:GetHandler():SetEntityCode(48, nil, nil, type, nil, nil, nil, nil, nil, nil, nil, nil, true)
        aux.CopyCardTable(48,e:GetHandler())
	end
end

function s.zarccost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function s.zarcspfilter(c, e, tp, sg)
	return c:IsCode(53) 
	and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION, tp, false, false) 
	and Duel.GetLocationCountFromEx(tp, tp, sg, c) > 0
end
function s.chk(c, sg, g, code, ...)
	if not c:IsSetCard(code) or not c:IsType(TYPE_MONSTER) then
		return false
	end
	local res
	if ... then
		g:AddCard(c)
		res = sg:IsExists(s.chk, 1, g, sg, g, ...)
		g:RemoveCard(c)
	else
		res = true
	end
	return res
end
function s.rescon(sg, e, tp, mg)
	return sg:IsExists(s.chk, 1, nil, sg, Group.CreateGroup(), 0x2073, 0x2017, 0x1046) 
	and Duel.GetLocationCountFromEx(tp, tp, sg, TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) > 0
end
function s.zarctg(e, tp, eg, ep, ev, re, r, rp, chk)
	local rg = Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove), tp, ZARC_LOC, 0, nil)
	local g1 = rg:Filter(Card.IsSetCard, nil, 0x2073)
	local g2 = rg:Filter(Card.IsSetCard, nil, 0x2017)
	local g3 = rg:Filter(Card.IsSetCard, nil, 0x1046)
	local g = g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	if chk == 0 then
		return #g1 > 0 and #g2 > 0 and #g3 > 0 and
				   Duel.IsExistingMatchingCard(s.zarcspfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, g) and
				   aux.SelectUnselectGroup(g, e, tp, 3, 3, s.rescon, 0)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end
function s.zarcop(e, tp, eg, ep, ev, re, r, rp)
	local rg = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, ZARC_LOC, 0, nil):Filter(function(c) return (c:IsSetCard(0x2073) or c:IsSetCard(0x2017) or c:IsSetCard(0x1046)) and c:IsType(TYPE_MONSTER) end, nil)
	local g = aux.SelectUnselectGroup(rg, e, tp, 3, 3, s.rescon, 1, tp, HINTMSG_REMOVE, nil, nil, false)
	if Duel.Remove(g, POS_FACEUP, REASON_EFFECT) > 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tc = Duel.SelectMatchingCard(tp, s.zarcspfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, g):GetFirst()
		if tc and Duel.SpecialSummon(tc, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP) > 0 then
			tc:CompleteProcedure()
		end
	end
	g:DeleteGroup()
end