--オーディンの眼
--Odin's Eye
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE) and not c:IsDisabled()
end
function s.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) then Duel.SetChainLimit(s.chlimit) end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g<1 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.ConfirmCards(tp,g1)
	Duel.ShuffleHand(1-tp)
end

function s.filter3(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE) and c:IsDestructable()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	Duel.SelectTarget(tp,s.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil) then Duel.SetChainLimit(s.chlimit) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if #g<1 or not c:IsSSetable() then return end
		Duel.SSet(tp,c)
	end
end