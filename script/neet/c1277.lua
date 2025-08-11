--极星神兽 亚斯维德(neet)
local s,id=GetID()
function s.initial_effect(c)
	-- Synchro summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x42),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	-- Effect 1: Summon token(s)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)   
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={1746}
s.listed_series={0x42,0x5042}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0x42)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10000020,0x42,TYPES_TOKEN+TYPE_TUNER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) and (not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or ct<2) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x42)
	if ct<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<ct or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and ct>1) or not Duel.IsPlayerCanSpecialSummonMonster(tp,10000020,0x42,TYPES_TOKEN+TYPE_TUNER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,10000020)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function s.filter(c,tp)
	local p=c:GetControler()
	return c:IsControler(tp) and c:IsFaceup() and c:GetSequence()>4 and Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if #g<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<#g then return end
	for tc in aux.Next(g) do
		e:SetLabelObject(tc)
		Duel.HintSelection(tc)
		local p1,p2,i
		if tc:IsControler(tp) then
			i=0
			p1=LOCATION_MZONE
			p2=0
		else
			i=16
			p2=LOCATION_MZONE
			p1=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)-i)
	end
	local tc=e:GetLabelObject()
	if tc~=nil and tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()<5 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x42) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsSetCard(0x5042) and c:IsAbleToHand()
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