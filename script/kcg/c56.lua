-- アストログラフ・マジシャン (Anime)
local s, id = GetID()
function s.initial_effect(c)
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
s.listed_series = {0x2073, 0x2017, 0x1046, 0x904}
s.listed_names = {53}

local ZARC_LOC = LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND + LOCATION_REMOVED

function s.zarccost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function s.zarcspfilter(c, e, tp, sg)
	return c:IsCode(55) 
	and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION+SUMMON_TYPE_RITUAL, tp, false, false) 
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
	return sg:IsExists(s.chk, 1, nil, sg, Group.CreateGroup(), 0x2073, 0x2017, 0x1046, 0x904) 
	and Duel.GetLocationCountFromEx(tp, tp, sg, TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) > 0
end
function s.zarctg(e, tp, eg, ep, ev, re, r, rp, chk)
	local rg = Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck), tp, ZARC_LOC, 0, nil)
	local g1 = rg:Filter(Card.IsSetCard, nil, 0x2073)
	local g2 = rg:Filter(Card.IsSetCard, nil, 0x2017)
	local g3 = rg:Filter(Card.IsSetCard, nil, 0x1046)
	local g4 = rg:Filter(Card.IsSetCard, nil, 0x904)
	local g = g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	g:Merge(g4)
	if chk == 0 then
		return #g1 > 0 and #g2 > 0 and #g3 > 0 and #g4 > 0 and
				   Duel.IsExistingMatchingCard(s.zarcspfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, g) and
				   aux.SelectUnselectGroup(g, e, tp, 4, 4, s.rescon, 0)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end
function s.zarcop(e, tp, eg, ep, ev, re, r, rp)
	local rg = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, ZARC_LOC, 0, nil):Filter(function(c) return (c:IsSetCard(0x2073) or c:IsSetCard(0x2017) or c:IsSetCard(0x1046) or c:IsSetCard(0x904)) and c:IsType(TYPE_MONSTER) end, nil)
	local g = aux.SelectUnselectGroup(rg, e, tp, 4, 4, s.rescon, 1, tp, HINTMSG_TODECK, nil, nil, false)
	if Duel.SendtoDeck(g, nil, 2, REASON_EFFECT) > 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tc = Duel.SelectMatchingCard(tp, s.zarcspfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, g):GetFirst()
		if tc and Duel.SpecialSummon(tc, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION+SUMMON_TYPE_RITUAL, tp, tp, false, false, POS_FACEUP) > 0 then
			tc:CompleteProcedure()
		end
	end
	g:DeleteGroup()
end