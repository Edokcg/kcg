--魔轰神 海拉尔
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_TUNER),3,nil,s.matcheck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.atkcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetTarget(s.efftg)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)
	aux.GlobalCheck(s,function()
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=0
		end)
	end)	
end
s.listed_series={0x35}
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x35,lc,sumtype,tp)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x35) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id)>0
	local b2=Duel.GetFlagEffect(tp,id+1)>0 and s[0]>=3
	local b3=Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,s[0]*100)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.floor(s[0]/3))
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFlagEffect(tp,id)>0
	local b2=Duel.GetFlagEffect(tp,id+1)>0 and s[0]>=3
	local b3=Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local break_chk=false
	if b1 then
		break_chk=true
		Duel.Recover(tp,s[0]*100,REASON_EFFECT)
	end
	if b2 then
		if break_chk then Duel.BreakEffect() end
		Duel.Draw(tp,math.floor(s[0]/3),REASON_EFFECT)
		break_chk=true
	end
	if b3 then
		if break_chk then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		break_chk=true
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+eg:FilterCount(Card.IsSetCard,nil,0x35)
	local g=eg:Filter(Card.IsSetCard,nil,0x35)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:IsRace(RACE_BEAST) then Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1) end
		if tc:IsRace(RACE_FIEND) then Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE|PHASE_END,0,1) end
		if tc:IsType(TYPE_SYNCHRO) then Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE|PHASE_END,0,1) end
	end
end