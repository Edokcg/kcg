--決闘竜 デュエル・リンク・ドラゴン
--Duel Link Dragon, the Duel Dragon
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,5,nil,s.lcheck)
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

	local e01=Effect.CreateEffect(c)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetValue(aux.lnklimit)
	c:RegisterEffect(e01)

	local e02 = Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_SET_ATTACK)
	e02:SetValue(s.atkvalue)
	c:RegisterEffect(e02)
	local e03 = e02:Clone()
	e03:SetCode(EFFECT_SET_DEFENSE)
	e03:SetValue(s.defvalue)
	c:RegisterEffect(e03)

	--Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tkcon)
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
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e15:SetCountLimit(1)
	e15:SetValue(1)
	c:RegisterEffect(e15)

	-- Search
	local e7 = Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10406322, 2))
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PREDRAW)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.schcon)
	e7:SetTarget(s.schtar)
	e7:SetOperation(s.schop)
	c:RegisterEffect(e7)
end

function s.spfilter(c,lc,sumtype,tp)
    return c:IsType(TYPE_SYNCHRO,lc,sumtype,tp) and c:IsRace(RACE_DRAGON)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:FilterCount(s.spfilter,nil,lc,sumtype,tp)>=5 and g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end

function s.atkvalue(e)
	local g = Duel.GetMatchingGroup(s.tgfilter, e:GetHandler():GetControler(), LOCATION_MZONE, 0, e:GetHandler())
	local tatk = 0
	local tc = g:GetFirst()
	while tc do
		local atk = tc:GetAttack()
		tatk = tatk + atk
		tc = g:GetNext()
	end
	return tatk
end
function s.defvalue(e)
	local g = Duel.GetMatchingGroup(s.tgfilter, e:GetHandler():GetControler(), LOCATION_MZONE, 0, e:GetHandler())
	local tdef = 0
	local tc = g:GetFirst()
	while tc do
		local def = tc:GetDefense()
		tdef = tdef + def
		tc = g:GetNext()
	end
	return tdef
end

function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, false)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft = Duel.GetLocationCountFromEx(tp, tp, nil, TYPE_SYNCHRO)
	if chk==0 then
		return ft>0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp, tp, nil, TYPE_SYNCHRO)<1 then return end
	local sg=Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	Duel.SpecialSummon(sg, SUMMON_TYPE_SYNCHRO, tp, tp, true, false, POS_FACEUP)
	for sg0 in aux.Next(sg) do
		sg0:CompleteProcedure()
	end
end

function s.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.schcon(e, tp, eg, ep, ev, re, r, rp)
	return tp == Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0 and Duel.GetDrawCount(tp) > 0
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