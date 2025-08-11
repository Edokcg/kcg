--黯黑之龙 墨菲斯托尔(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Special summon itself from hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,{id,0})
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.scon0)
	e1:SetCost(s.cost)
	e1:SetTarget(s.stg0)
	e1:SetOperation(s.sop0)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return not (c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and not g:IsExists(s.filter,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.scon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter,1,nil,1-tp)
		and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD|LOCATION_HAND,0)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsAttribute,1,false,nil,e:GetHandler(),ATTRIBUTE_DARK) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsAttribute,1,1,false,nil,e:GetHandler(),ATTRIBUTE_DARK)
	Duel.Release(g,REASON_COST)
end
function s.stg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,eg,#eg,1-tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,eg,#eg,1-tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.sop0(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp,eg)
	local c=e:GetHandler()
	local b1=eg:GetFirst():IsAbleToDeck()
	local b2=c:IsRelateToEffect(e) and c:IsDestructable() and eg:GetFirst():IsAbleToHand(tp)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,3)},
		{b2,aux.Stringid(id,2)})
	if op==1 then
		local tb=Duel.SelectEffect(tp,
			{1,aux.Stringid(id,0)},
			{1,aux.Stringid(id,1)})
		if tb==1 then
			Duel.SendtoDeck(eg,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(eg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	else
		if Duel.Destroy(c,REASON_EFFECT)~=0 then Duel.SendtoHand(eg,tp,REASON_EFFECT) end
	end
end