--王家の神殿
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e2)

	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(s.econ)
	e4:SetValue(s.elimit)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		--activate limit
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetRange(LOCATION_MZONE)
		ge1:SetOperation(s.aclimit1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetRange(LOCATION_MZONE)
		ge2:SetOperation(s.aclimit2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1)
		ge3:SetOperation(s.clear)
		Duel.RegisterEffect(ge3,0)
	end)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
    e5:SetLabelObject(e3)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target2)
	e5:SetOperation(s.operation2)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCost(s.cost3)
	e6:SetTarget(s.target3)
	e6:SetOperation(s.operation3)
	c:RegisterEffect(e6)
	
	--Add 1 monster that mentions "Temple of the Kings" from your Deck to your hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,5))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.thcon)
	e7:SetTarget(s.thtg)
	e7:SetOperation(s.thop)
	c:RegisterEffect(e7)
end
s.listed_names={89194033,CARD_TEMPLE_OF_THE_KINGS}
s.listed_series={SET_APOPHIS}

function s.setfilter(c)
	return c:IsSetCard(SET_APOPHIS) and c:IsTrap() and c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg)
	end
end

function s.cfilter(c)
	return c:IsAbleToRemove() and c:IsMonster()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    e:SetLabelObject(g:GetFirst())
    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(s.efilter)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    g:GetFirst():RegisterEffect(e2, true)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	s[ep]=s[ep]+1
end
function s.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	s[ep]=s[ep]-1
end
function s.clear(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
end
function s.econ(e)
	return s[1-e:GetHandlerPlayer()]>=2
end
function s.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.rfilter(tc)
    local c1,c2=tc:GetTributeRequirement()
	if not (tc:IsType(TYPE_MONSTER) and tc:IsSummonable(true, nil)) then
		return false
	end
	return true
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and s.rfilter(tc) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,tc,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
    local c1,c2=tc:GetTributeRequirement()
	if tc and s.rfilter(tc) then
		local s2 = tc:IsSummonable(true, nil)
		if s2 then
			Duel.Summon(tp, tc, true, nil, 0)
            local e1235=Effect.CreateEffect(e:GetHandler())
            e1235:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
            e1235:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
            e1235:SetCode(EVENT_LEAVE_FIELD)
            e1235:SetOperation(s.lose)
            tc:RegisterEffect(e1235)
		end
	end
end

function s.lose(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(1-tp,0)
end

function s.cfilter3(c,e,tp,rp)
	if c:IsFacedown() or not c:IsCode(89194033) or not c:IsAbleToGraveAsCost() then return false end
	return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_EXTRA,0,1,nil,e,tp,rp,Group.FromCards(c,e:GetHandler()))
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,rp)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.filter3(c,e,tp,rp,sg)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if c:IsLocation(LOCATION_HAND|LOCATION_DECK) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else
		return c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,rp,sg,c)>0
	end
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_EXTRA)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_EXTRA,0,1,1,nil,e,tp,rp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,nil)
		or Duel.IsExistingMatchingCard(Card.IsTrap,tp,LOCATION_GRAVE,0,1,nil)
end
function s.thfilter(c)
	return c:IsMonster() and c:ListsCode(CARD_TEMPLE_OF_THE_KINGS) and c:IsAbleToHand()
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