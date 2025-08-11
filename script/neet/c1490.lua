--PSY骨架控制员(neet)	
local s,id=GetID()
function s.initial_effect(c)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetValue(CARD_PSYFRAME_DRIVER)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Alpha
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(id,1))
	ea:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ea:SetRange(LOCATION_HAND)
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	ea:SetCondition(s.alphacon)
	ea:SetCost(s.cost)
	ea:SetCountLimit(1,{id,1})
	ea:SetLabel(75425043)
	ea:SetTarget(s.alphatg)
	ea:SetOperation(s.alphaop)
	c:RegisterEffect(ea)
	local ea2=ea:Clone()
	ea2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ea2)
	--Bate
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(id,2))
	eb:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	eb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	eb:SetRange(LOCATION_HAND)
	eb:SetCode(EVENT_ATTACK_ANNOUNCE)
	eb:SetCondition(s.batecon)
	eb:SetCountLimit(1,{id,1})
	eb:SetCost(s.cost)
	eb:SetLabel(2810642)
	eb:SetTarget(s.batetg)
	eb:SetOperation(s.bateop)
	c:RegisterEffect(eb)
	--Gamma
	local ega=Effect.CreateEffect(c)
	ega:SetDescription(aux.Stringid(id,3))
	ega:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY)
	ega:SetType(EFFECT_TYPE_QUICK_O)
	ega:SetRange(LOCATION_HAND)
	ega:SetCode(EVENT_CHAINING)
	ega:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ega:SetCountLimit(1,{id,1})
	ega:SetCondition(s.gammacon)
	ega:SetCost(s.cost)
	ega:SetLabel(38814750)
	ega:SetTarget(s.gammatg)
	ega:SetOperation(s.gammaop)
	c:RegisterEffect(ega)
	--Delta
	local ed=ega:Clone()
	ed:SetDescription(aux.Stringid(id,4))
	ed:SetCountLimit(1,{id,1})
	ed:SetLabel(74203495)
	ed:SetCondition(s.edcon)
	c:RegisterEffect(ed)
	--Epsilon
	local ee=ega:Clone()
	ee:SetDescription(aux.Stringid(id,5))
	ee:SetCountLimit(1,{id,1})
	ee:SetLabel(1697104)
	ee:SetCondition(s.eecon)
	c:RegisterEffect(ee)
end
s.listed_names={CARD_PSYFRAME_DRIVER}
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST|REASON_DISCARD)
end
function s.thfilter(c)
	return c:IsSetCard(0xc1) and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.filter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
	e:SetLabelObject(g:GetFirst())
end
--Alpha--
function s.alphacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_PSYFRAME_LAMBDA))
end
function s.spfilter1(c,e,tp)
	return c:IsCode(CARD_PSYFRAME_DRIVER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,c)
end
function s.spfilter2(c,e,tp)
	return c:IsCode(CARD_PSYFRAME_DRIVER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.thfilter0,tp,LOCATION_DECK,0,1,c)
end
function s.thfilter0(c)
	return c:IsSetCard(0xc1) and not c:IsCode(id)
end
function s.thfilter(c)
	return c:IsSetCard(0xc1) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.alphatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.alphaop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local lv=e:GetLabelObject():GetLevel()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetValue(lv)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	e11:SetValue(TYPE_TUNER)
	c:RegisterEffect(e11)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g2>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
--Alpha--
--remove--
function s.rmfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
--remove--
--Beta--
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.batecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_PSYFRAME_LAMBDA))
end
function s.spfilter(c,e,tp)
	return c:IsCode(CARD_PSYFRAME_DRIVER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.batetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetAttacker():IsRelateToBattle()
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function s.bateop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	local lv=e:GetLabelObject():GetLevel()
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetValue(lv)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	e11:SetValue(TYPE_TUNER)
	c:RegisterEffect(e11)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	Duel.RegisterEffect(e1,tp)
	local dc=Duel.GetFirstTarget()
	if dc:IsRelateToEffect(e) and Duel.Destroy(dc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
--Bata--
--Gamma--
function s.gammacon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_PSYFRAME_LAMBDA))
end
function s.gammatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.gammaop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local lv=e:GetLabelObject():GetLevel()
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetValue(lv)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_ADD_TYPE)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	e11:SetValue(TYPE_TUNER)
	c:RegisterEffect(e11)
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	Duel.RegisterEffect(e1,tp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--Gamma--
--Delta--
function s.edcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_PSYFRAME_LAMBDA))
end
--Delta--
--Epsilon--
function s.eecon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_PSYFRAME_LAMBDA))
end
--Epsilon--