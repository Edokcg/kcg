--オッドアイズ・フュージョンゲート
--Odd-Eyes Fusiongate
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_series = {0x99}
s.listed_names={511015105, 511015106}

function s.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0x99) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))
end
function s.filter3(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.IsPlayerCanSpecialSummonCount(tp,2) 
			and aux.CheckSummonGate(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetUsableMZoneCount(tp)>1 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst())
	if #g2<1 then return end
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)<=0 or Duel.GetUsableMZoneCount(tp)<=1 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) > 0 then
		for tc in aux.Next(sg) do
			if tc:IsLocation(LOCATION_MZONE) then
				s.disop(tc,e:GetHandler())
			end
		end
	else
		return
	end
	Duel.BreakEffect()
	local sc=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg,nil):GetFirst()
	if sc then
		sc:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id, 0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(s.descon)
		e1:SetTarget(s.destg)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(sc)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id, 1))
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetHintTiming(TIMING_DAMAGE_STEP)
		e2:SetCondition(s.atkcon)
		e2:SetCost(s.atkcost)
		e2:SetTarget(s.atktg)
		e2:SetOperation(s.atkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(sc)
		c:RegisterEffect(e2)
	end
end
function s.disop(tc,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x99) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.atkcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsBattlePhase() and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function s.costfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function s.atkcost(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil,511015104)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil,511015105) end
	local g1=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,511015104)
	if #g1<1 then return end
	local g2=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,511015105)
	if #g2<1 then return end
	g1:Merge(g2)
	g1:AddCard(e:GetHandler())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:IsLocation(LOCATION_MZONE) and tc:GetFlagEffect(id)>0 end
	Duel.SetTargetCard(tc)
end
function s.atkop(e,tp,eg,ev,ep,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end