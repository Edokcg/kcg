--救祓少女之靈(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	Link.AddProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(function() return Duel.IsMainPhase() end)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
function s.matfilter(c,sc,st,tp)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER,sc,st,tp)
end
function s.matfilter2(c)
	return c:IsType(TYPE_XYZ)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(s.matfilter2,nil)
	return c:IsSummonType(SUMMON_TYPE_LINK) and g:GetCount()>0
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x174) and c:IsLevelBelow(4) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc,e,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil,e,tp,ft)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	aux.ToHandOrElse(tc,tp,
		function()
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		end,
		function()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end,
		aux.Stringid(id,2) --"Special Summon it"
	)
end
function s.spfilter(c,e,tp,mc,pg)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x174) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and mc:IsCanBeXyzMaterial(c,tp) and (#pg<=0 or pg:IsContains(mc)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
		return #pg<=1 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,pg):GetFirst()
	if not sc then return end
	sc:SetMaterial(c)
	Duel.Overlay(sc,c)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end