--太阳神的翼神龙-变形体(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK|LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2) 
end
s.listed_names={CARD_RA,10000080,10000090}
function s.spfilter(c,tp)
	return c:IsCode(10000080) and c:IsFaceup() and c:IsReleasable()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE)
	if rg then
		rg:KeepAlive()
		e:SetLabelObject(rg)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	if g:GetFirst():IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3206)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and not c:IsLocation(LOCATION_DECK)
end
function s.filter(c,e,tp)
	return c:IsCode(CARD_RA) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.tgfilter(c)
	return c:IsCode(10000090) and c:IsAbleToGrave()
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK|LOCATION_HAND)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end