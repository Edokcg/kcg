local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)	
	c:RegisterEffect(e1)

	--immune
	-- local e16=Effect.CreateEffect(c)
	-- e16:SetType(EFFECT_TYPE_FIELD)
	-- e16:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	-- e16:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e16:SetRange(LOCATION_FZONE)
	-- e16:SetTargetRange(LOCATION_SZONE+LOCATION_HAND,0)
	-- e16:SetValue(s.efilter)
	-- c:RegisterEffect(e16)

	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e17:SetCode(EFFECT_IMMUNE_OVERLAY)
	e17:SetRange(LOCATION_FZONE)
	e17:SetTargetRange(LOCATION_SZONE+LOCATION_HAND,0)
	e17:SetValue(1)
	c:RegisterEffect(e17)

	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM+TYPE_RITUAL))
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)

	--type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCode(EFFECT_CHANGE_TYPE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM+TYPE_RITUAL))
	e3:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(e3)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_PREEFFECT_DRAW)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTarget(s.hdtg)
	c:RegisterEffect(e11)

	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetCost(s.ccost)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.ctarget)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)    
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() 
end

function s.cfilter(c)
	return c:IsCode(511009541) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<1 then return end
	Duel.SendtoGrave(g,REASON_COST)
end
function s.filter(c)
	return c:IsCode(511009533,511009536,511009535,511009534,66) and c:IsSSetable()
end
function s.filter1(c,code)
	return c:IsCode(code) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND) and s.filter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	-- if e:GetHandler():IsLocation(LOCATION_HAND) then
	-- 	ft=ft-1
	-- end
	if chk==0 then return ft>4 and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,511009533) and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,511009536) and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,511009535) and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,511009534) and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,66) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,511009533)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g2=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,511009536)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g3=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,511009535)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g4=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,511009534)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g5=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,66)
    g1:Merge(g2) g1:Merge(g3) g1:Merge(g4) g1:Merge(g5)
    Duel.SetTargetCard(g1)
    local g=g1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if g:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<#g then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SSet(tp,tc)
		tc=g:GetNext()
	end
end

function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return ep==tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)>0 end
	if not Duel.SelectYesNo(tp, aux.Stringid(18631392, 0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
    e:SetLabel(ac)
	e:SetOperation(s.hdop)
	--Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)<1 or e:GetLabel()<1 then return end
    local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_HAND)
	e11:SetCondition(s.hdcon2)
	e11:SetOperation(s.hdop2)
    e11:SetLabel(e:GetLabel())
    e11:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e11,tp)
end
function s.cfilter3(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.cfilter2(c,tp,label)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
    and c:IsCode(label)
end
function s.hdcon2(e,tp,eg,ep,ev,re,r,rp)
    local label=e:GetLabel()
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter3,1,nil,tp)
end
function s.hdop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetOwner()
	local label=e:GetLabel()
    local g=eg:Filter(s.cfilter2,nil,tp,label)
	if g:GetCount()<1 then
		if Duel.GetTurnPlayer()==tp then
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_EP)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			Duel.RegisterEffect(e1,tp)
		end
		return
	end
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)>0 then Duel.Draw(tp, 1, REASON_EFFECT) end
    e:Reset()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return re:GetHandler():IsCode(511009533) and not e:GetHandler():IsStatus(STATUS_CHAINING) and g:GetCount()>0
    and re and re:IsHasType(EFFECT_TYPE_IGNITION) and re:GetDescription()==aux.Stringid(1353770,0)
end
function s.scfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)>0 end
	Duel.DiscardDeck(tp, Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0), REASON_COST)
end
function s.ctarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009533) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009536) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009535) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009534) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,66) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)    
    if not (Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009533) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009536) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009535) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511009534) and Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_ONFIELD,0,1,nil,66)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil,511009533)
	if #g1<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil,511009536)
	if #g2<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g3=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil,511009535)
	if #g3<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g4=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil,511009534)
	if #g4<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g5=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil,66)
	if #g5<1 then return end
    g1:Merge(g2) g1:Merge(g3) g1:Merge(g4) g1:Merge(g5)
    if g1:GetCount()<1 then return end
	Duel.SendtoDeck(g1, tp, 2, REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
end
