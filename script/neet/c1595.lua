--暗黑界的邪神 布鲁德
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	 Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),3,3)
	c:EnableReviveLimit()
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(1595)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.cetcon)
	c:RegisterEffect(e1)
	--
	if not s.globle_check then
		s.globle_check=true
		--return replace
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_SEND_REPLACE)
		ge1:SetLabelObject(ge2)
		ge1:SetTarget(s.reptg)
		ge1:SetValue(s.repval)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,1)
	end
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1595,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1595,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_DARK_WORLD}
function s.cetcon(e)
	return e:GetHandler():GetSequence()>4
end
function s.repfilter(c)
	local tp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,1595) and c:IsLocation(LOCATION_HAND)
		and c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(1595)==0
end
function s.repfilter2(c)
	local tp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,1595) and c:IsLocation(LOCATION_HAND) and c:GetDestination()==LOCATION_GRAVE 
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return r==REASON_EFFECT+REASON_DISCARD and re
		and eg:IsExists(s.repfilter,1,nil) and rp~=tp end
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetControler()
		if Duel.IsPlayerAffectedByEffect(pl,1595) and tc:IsLocation(LOCATION_HAND)
		and tc:GetDestination()==LOCATION_GRAVE and tc:GetFlagEffect(1595)==0 then
			tc:RegisterFlagEffect(1595,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
	local sg=eg:Filter(s.repfilter2,nil)
	if sg:GetCount()<=0 then return false end
	Duel.Hint(HINT_CARD,0,1595)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	return true
end
function s.repval(e,c)
	local tp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,1595) and c:IsLocation(LOCATION_HAND)
		and c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(1595)==0
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6)
end
function s.dcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	local g=g:Filter(s.ctfilter,nil)
	if chk==0 then return c:GetFlagEffect(1595)<1+g:GetCount() and Duel.IsExistingMatchingCard(s.dcfilter,tp,LOCATION_HAND,0,1,nil) end
	c:RegisterFlagEffect(1595,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.DiscardHand(tp,s.dcfilter,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsSetCard(0x6) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
