--海造贼-黑胡子二世
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1587,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1587)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1587,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.atttg)
	e2:SetOperation(s.attop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.fufilter(c,mg,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x13f)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,tp)
end
function s.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2) and c:IsSetCard(0x13f)
end
function s.synfilter(c,mg)
	return c:IsSetCard(0x13f) and c:IsSynchroSummonable(nil,mg)
end
function s.lkfilter(c,mg)
	return c:IsSetCard(0x13f) and c:IsLinkSummonable(mg,nil,2,2)
end
function s.filter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mfilter1(c,mg,exg,e)
	return mg:IsExists(s.mfilter2,1,c,c,exg,e)
end
function s.mfilter2(c,mc,exg,e)
	return exg:IsExists(s.xyzfilter,1,nil,Group.FromCards(c,mc)) or exg:IsExists(s.synfilter,1,nil,Group.FromCards(c,mc)) or exg:IsExists(s.fufilter,1,nil,Group.FromCards(c,mc),e,c:GetControler()) or exg:IsExists(s.lkfilter,1,nil,Group.FromCards(c,mc))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local xexg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	local sexg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
	local fexg=Duel.GetMatchingGroup(s.fufilter,tp,LOCATION_EXTRA,0,nil,mg,e,tp)
	local lexg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,mg)
	xexg:Merge(sexg)
	xexg:Merge(fexg)
	xexg:Merge(lexg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and mg:IsExists(s.mfilter1,1,nil,mg,xexg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,s.mfilter1,1,1,nil,mg,xexg,e)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,s.mfilter2,1,1,tc1,tc1,xexg,e)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function s.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local exg=Group.CreateGroup()
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	local syng=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,g)
	local fusg=Duel.GetMatchingGroup(s.fufilter,tp,LOCATION_EXTRA,0,nil,g,e,tp)
	local linkg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,g)
	exg:Merge(xyzg)
	exg:Merge(syng)
	exg:Merge(fusg)
	exg:Merge(linkg)
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=exg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		e:SetLabelObject(tg)
		tg:KeepAlive()
		if tc:IsType(TYPE_XYZ) then
			Duel.XyzSummon(tp,tc,g)
		end
		if tc:IsType(TYPE_LINK) then
			Duel.LinkSummon(tp,tc,g,nil,2,2)
		end
		if tc:IsType(TYPE_SYNCHRO) then
			Duel.SynchroSummon(tp,tc,nil,g)
		end
		if tc:IsType(TYPE_FUSION) then
			tc:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)==0 then return false end
			if tc and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) then
				if not Duel.Equip(tp,c,tc,false) then return end
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(tc)
				e1:SetValue(s.eqlimit)
				c:RegisterEffect(e1)
			end
		end
	end
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tg)
	e1:SetCondition(s.eqcon)
	e1:SetOperation(s.eqop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	return eg:IsContains(tc)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	if tc and tc:IsFaceup() and c:IsFaceup() and c:IsControler(tp) then
		if not Duel.Equip(tp,c,tc,false) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
	end
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(att)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
