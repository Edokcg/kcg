--圣星辉龙-神数星圣(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c,false)
	--2 Level 4 Pendulum monsters
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_PENDULUM),4,2) 
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1,{id,0})
	e0:SetCondition(function(e,tp) return Duel.IsTurnPlayer(tp) end) 
	e0:SetTarget(s.thtg)
	e0:SetOperation(s.thop)
	c:RegisterEffect(e0) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)  
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2) 
end
s.pendulum_level=4
s.listed_series={0xc4,0x53,0x9c}
function s.filter(c)
	return (c:IsSetCard(0xc4) or c:IsSetCard(0x9c) or c:IsSetCard(0x53)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	-- Neither player can Special Summon from the GY
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(0,1)
	e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) end)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.tdfilter(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsAttribute(ATTRIBUTE_DARK) and c:IsRelateToEffect(e) and Duel.CheckPendulumZones(tp) and c:IsType(TYPE_PENDULUM) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then 
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end