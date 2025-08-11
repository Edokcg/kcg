--神隐
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DRAW)
	e0:SetCondition(s.regcon)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)

	--检索卡组交换手牌幻神卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(811734,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={39913299}

function s.thfilter(c)
	return c:IsCode(40703222) and c:IsAbleToHand()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.filter1(c,tp)
	return c:IsRace(RACE_DIVINE) and c:IsAbleToDeck() and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end

function s.filter2(c,lv)
	return c:IsRace(RACE_DIVINE) and c:GetLevel()==lv and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #g1<1 then return end
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetLevel())
	if #g2<1 then return end
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
end
