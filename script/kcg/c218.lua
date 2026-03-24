--決闘竜 デュエル・リンク・ドラゴン
--Duel Link Dragon, the Duel Dragon
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,4,s.lcheck)
	Synchro.AddProcedure(c,s.syfilter,1,1,Synchro.NonTuner(nil),1,99,nil,nil,nil,s.matfilter)
    aux.god(c,3,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(3)
    c:RegisterEffect(e001)
	c:EnableReviveLimit()
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_DRAGON+RACE_CREATORGOD)
	c:RegisterEffect(e0)
	local e01 = e0:Clone()
	e01:SetCode(EFFECT_ADD_ATTRIBUTE)
	e01:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e01)

	local e02 = Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e02:SetCode(EFFECT_UPDATE_ATTACK)
	e02:SetRange(LOCATION_MZONE)
	e02:SetValue(s.atkvalue)
	c:RegisterEffect(e02)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,7))
	e5:SetCategory(CATEGORY_TOEXTRA|CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.negcon)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)

	--Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)

	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.tgcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

	-- Search
	local e7 = Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PREDRAW)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.schcon)
	e7:SetTarget(s.schtar)
	e7:SetOperation(s.schop)
	c:RegisterEffect(e7)
end
s.listed_names={CARD_CRIMSON_DRAGON}

function s.syfilter(c,sc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,sc,sumtype,tp) and c:IsType(TYPE_SYNCHRO,sc,SUMMON_TYPE_SYNCHRO,tp)
end

function s.matfilter(g,sc,tp)
	return g:IsExists(s.scfilter,1,nil,sc,tp)
end
function s.scfilter(c,sc,tp)
	return c:IsType(TYPE_SYNCHRO,sc,SUMMON_TYPE_SYNCHRO,tp) and c:IsRace(RACE_DRAGON,sc,SUMMON_TYPE_SYNCHRO,tp) and not c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp)
end

function s.lvfilter(c,lc,sumtype,tp,g)
	return c:IsType(TYPE_SYNCHRO,lc,sumtype,tp) and c:IsRace(RACE_DRAGON,lc,sumtype,tp) and c:IsType(TYPE_TUNER,lc,sumtype,tp) and g:IsExists(s.lvfilter2,1,c,lc,sumtype,tp)
end
function s.lvfilter2(c,lc,sumtype,tp)
	return c:IsType(TYPE_SYNCHRO,lc,sumtype,tp) and c:IsRace(RACE_DRAGON,lc,sumtype,tp) and not c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.lvfilter,1,nil,lc,sumtype,tp,g)
end

function s.atkvalue(e)
	return Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSynchroMonster),e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler()):GetSum(Card.GetAttack)
end

function s.spfilter0(c,e,tp)
	return c:IsSynchroMonster() and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsSpellTrap() and c:ListsCode(CARD_CRIMSON_DRAGON) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter0,tp,LOCATION_GRAVE,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter0,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),#g)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=math.min(ft,1) end
	local yesno=false
	if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		yesno=true
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	if not yesno or Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp==1-tp and re:IsMonsterEffect()
end
function s.negfilter(c)
	return c:IsFaceup() and c:IsSynchroMonster() and c:IsRace(RACE_DRAGON) and c:IsAbleToDeck()
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local exc=c:IsRelateToEffect(e) and c or nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.negfilter,tp,LOCATION_MZONE,0,1,1,exc)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.NegateActivation(ev)
	end
end

function s.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, false) and c:IsLevelBelow(10)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local opt=0
	local ft = Duel.GetLocationCountFromEx(tp, tp, nil, TYPE_SYNCHRO)
	local b1=ft>0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=c:IsAbleToExtra() and Duel.IsExistingTarget(s.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e,tp,c)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and s.cfilter2(chkc,e,tp,c) end
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and s.cfilter2(chkc,e,tp,c) end
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else 
		opt=2 
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif opt==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,e,tp,c)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCountFromEx(tp, tp, nil, TYPE_SYNCHRO)<1 then return end
		local sg=Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
		Duel.SpecialSummon(sg, SUMMON_TYPE_SYNCHRO, tp, tp, true, false, POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	elseif e:GetLabel()==1 then
		if not (c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA)) then return end
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel()):GetFirst()
			if not sc then return end
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end

function s.cfilter2(c,e,tp,mc)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsType(TYPE_SYNCHRO) and c~=e:GetHandler()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),mc)
end
function s.spfilter(c,e,tp,lvl,mc)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lvl) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and s.tgfilter(chkc,e,tp,c) end
	if chk==0 then return c:IsAbleToExtra() and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA)) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel()):GetFirst()
		if not sc then return end
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end

function s.tgfilter0(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.tgfilter0),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end

function s.schcon(e, tp, eg, ep, ev, re, r, rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
end
function s.schfilter(c,tid)
	return c:IsCode(21159309) and c:IsAbleToHand() and c:GetTurnID()==tid
end
function s.schtar(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	local dt = Duel.GetDrawCount(tp)
	if dt ~= 0 then
		_replace_count = 0
		_replace_max = dt
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1, 0)
		e1:SetReset(RESET_PHASE + PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function s.schop(e, tp, eg, ep, ev, re, r, rp)
	_replace_count = _replace_count + 1
	if _replace_count > _replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then
		return
	end
	local code = 21159309
	local gg = Group.FromCards(Duel.CreateToken(tp, code))
	Duel.SendtoDeck(gg, tp, SEQ_DECKTOP, REASON_RULE)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.schfilter, tp, LOCATION_DECK, 0, 1, 1, nil,Duel.GetTurnCount(),e,tp)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_RULE)
		Duel.ConfirmCards(1 - tp, g)
	end
end