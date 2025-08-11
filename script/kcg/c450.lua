--クロノグラフ・マジシャン
--Chronograph Sorcerer
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--Take 1 "Timegazer Magician" and either place it in the Pendulum zone or Special Summon it
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(s.rptg)
	e1:SetOperation(s.rpop)
	c:RegisterEffect(e1)
	--Special Summon this card from your hand then you can Special Summon 1 monster from your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	-- Special Summon Supreme King Z-Arc
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.zarccost)
	e3:SetTarget(s.zarctg)
	e3:SetOperation(s.zarcop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_PENDULUM_DRAGON,SET_XYZ_DRAGON,SET_SYNCHRO_DRAGON,SET_FUSION_DRAGON}
s.listed_names={CARD_ZARC,20409757} --"Timegazer Magician"

local ZARC_LOC = LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND + LOCATION_EXTRA + LOCATION_DECK

function s.rpfilter(c,e,tp)
	return c:IsCode(20409757) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rpfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_HAND)
end
function s.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,6))
		local g=Duel.SelectMatchingCard(tp,s.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE|REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
		return
	end
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c)
	return c:IsSetCard({SET_PENDULUM_DRAGON,SET_XYZ_DRAGON,SET_SYNCHRO_DRAGON,SET_FUSION_DRAGON}) and c:IsMonster() 
		and c:IsAbleToRemoveAsCost() and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
		and (c:IsLocation(LOCATION_HAND) or aux.SpElimFilter(c,true,true))
end
function s.rescon(checkfunc)
	return function(sg,e,tp,mg)
		if not sg:CheckDifferentProperty(checkfunc) then return false,true end
		return Duel.IsExistingMatchingCard(s.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
	end
end
function s.zarccost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(), REASON_COST)
end
function s.zarcspfilter(c, e, tp, sg)
	return c:IsCode(13331639) 
	and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION+SUMMON_TYPE_PENDULUM, tp, false, false) 
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
	return sg:IsExists(s.chk, 1, nil, sg, Group.CreateGroup(), 0x10f2, 0x2073, 0x2017, 0x1046) 
	and Duel.GetLocationCountFromEx(tp, tp, sg, TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM) > 0
end
function s.zarctg(e, tp, eg, ep, ev, re, r, rp, chk)
    local rg = Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove), tp, ZARC_LOC, 0, nil)
    local g1 = rg:Filter(Card.IsSetCard, nil, 0x10f2)
    local g2 = rg:Filter(Card.IsSetCard, nil, 0x2073)
    local g3 = rg:Filter(Card.IsSetCard, nil, 0x2017)
    local g4 = rg:Filter(Card.IsSetCard, nil, 0x1046)
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
    local rg = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, ZARC_LOC, 0, nil):Filter(function(c) return (c:IsSetCard(0x10f2) or c:IsSetCard(0x2073) or c:IsSetCard(0x2017) or c:IsSetCard(0x1046)) and c:IsType(TYPE_MONSTER) end, nil)
    local g = aux.SelectUnselectGroup(rg, e, tp, 4, 4, s.rescon, 1, tp, HINTMSG_REMOVE, nil, nil, false)
    if Duel.Remove(g, POS_FACEUP, REASON_EFFECT) > 3 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local tc = Duel.SelectMatchingCard(tp, s.zarcspfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, g):GetFirst()
        if tc and Duel.SpecialSummon(tc, SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_FUSION+SUMMON_TYPE_PENDULUM, tp, tp, false, false, POS_FACEUP) > 0 then
            tc:CompleteProcedure()
        end
    end
    g:DeleteGroup()
end