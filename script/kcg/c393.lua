--時械聖域(KDIY)
local s,id=GetID()
function s.initial_effect(c)
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_ORICA)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetValue(s.effectfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.condition2)
	e5:SetTarget(s.target4)
	e5:SetOperation(s.operation2)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCondition(s.condition1)
	e6:SetTarget(s.tdtg)
	e6:SetOperation(s.tdop)
	c:RegisterEffect(e6)
end
s.listed_series = {0x4a}
s.listed_names = {9409625}

function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_TRAP) and bit.band(te:GetActivateLocation(),LOCATION_HAND)~=0
end

function s.condition2(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsTurnPlayer(tp)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter2(c)
	return c:IsSetCard(0x4a) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
	end
end

function s.condition1(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.tdfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc)
	end
	if chk == 0 then
		return Duel.IsExistingTarget(s.tdfilter, tp, LOCATION_GRAVE, 0, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
end
function s.setfilter(c)
	return c:IsCode(9409625) and c:IsSSetable()
end
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc, nil, 2, REASON_EFFECT) ~= 0 then
		local g = Duel.GetMatchingGroup(s.setfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			local sc = g:Select(tp, 1, 1, nil):GetFirst()
			Duel.SSet(tp, sc)
		end
	end
end

