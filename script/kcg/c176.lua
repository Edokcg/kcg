--無限光アイン・ソフ・オウル
local s,id=GetID()
function s.initial_effect(c)
	--Activate to Grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.acttg)
	c:RegisterEffect(e1)

	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--untarget
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_TIMELORD))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot to deck
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_DECK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_TIMELORD))
	c:RegisterEffect(e4)

	--special summon
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(s.target4)
	e5:SetOperation(s.operation2)
	c:RegisterEffect(e5)

	-- to Grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(s.drcost)
	e6:SetTarget(s.drtg)
	e6:SetOperation(s.drop)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_SET)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCost(s.cost)
	e7:SetTarget(s.tdtg)
	e7:SetOperation(s.tdop)
	c:RegisterEffect(e7)
	
	--Salvage "Nonexistance"
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,4))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(s.thcon)
	e8:SetTarget(s.thtg)
	e8:SetOperation(s.thop)
	c:RegisterEffect(e8)

	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(id-1)
	e10:SetTargetRange(1,0)
	e10:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e10)
	aux.ChangePlayerEffect({EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_CANNOT_SUMMON,EFFECT_CANNOT_FLIP_SUMMON},c,id-1,function(te,tc) return Duel.GetPlayerEffect(te:GetOwnerPlayer(),id-1) and tc:IsSetCard(SET_TIMELORD) end)
end
s.listed_series = {SET_TIMELORD}
s.listed_names={9409625,36894320,8967776}

function s.acfilter(c)
	return c:IsFaceup() and c:IsCode(36894320) and c:IsAbleToGraveAsCost()
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.acfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b0=s.target4(e,tp,eg,ep,ev,re,r,rp,0)
	local b1=s.drcost(e,tp,eg,ep,ev,re,r,rp,0)
		and s.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=s.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and s.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b0 or b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		local sel = 0
		local off = 1
		local ops = {}
		local opval = {}
		if b0 then
			ops[off] = aux.Stringid(id, 0)
			opval[off - 1] = 1
			off = off + 1
		end
		if b1 then
			ops[off] = aux.Stringid(id, 1)
			opval[off - 1] = 2
			off = off + 1
		end
		if b2 then
			ops[off] = aux.Stringid(id, 2)
			opval[off - 1] = 3
			off = off + 1
		end
		local op = Duel.SelectOption(tp, table.unpack(ops))
		if opval[op]==1 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			s.target4(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(s.operation2)
		elseif opval[op]==2 then
			e:SetCategory(CATEGORY_DRAW)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			s.drcost(e,tp,eg,ep,ev,re,r,rp,1)
			s.drtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(s.drop)
		else
			e:SetCategory(CATEGORY_TODECK)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			s.cost(e,tp,eg,ep,ev,re,r,rp,1)
			s.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(s.tdop)
		end
	end
end

function s.filter(c, e, sp)
	return c:IsSetCard(SET_TIMELORD) and c:IsCanBeSpecialSummoned(e, 0, sp, true, false)
end
function s.target4(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end
function s.operation2(e, tp, eg, ep, ev, re, r, rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not e:GetHandler():IsRelateToEffect(e) or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
end
function s.drfilter(c)
	return c:GetLevel()==10 and c:IsDiscardable()
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_HAND,0,1,nil)
		and s.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.DiscardHand(tp,s.drfilter,1,1,REASON_COST|REASON_DISCARD)
	s.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.tdfilter(c)
	return c:IsSetCard(SET_TIMELORD) and c:IsMonster() and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.setfilter(c)
	return c:IsCode(36894320) and c:IsSSetable()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
		end
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.thfilter(c)
	return c:IsCode(9409625) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end