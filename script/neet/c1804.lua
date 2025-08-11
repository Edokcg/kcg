--三形金字塔的祭司(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)   
	--field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(function(_,tp) return Duel.GetTurnPlayer()==1-tp end)
	e3:SetTarget(s.fetg)
	e3:SetOperation(s.feop)
	c:RegisterEffect(e3)
end
s.listed_series={0xe2}
function s.filter2(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_FZONE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter2,1,nil)
end
function s.thfilter(c,tp)
	return c:IsSetCard(0xe2) and c:IsContinuousSpellTrap() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function s.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe2) and c:IsType(TYPE_FIELD) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),tp)
end
function s.cfilter(c,code,tp)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0xe2) and not c:IsCode(code) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.fetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.feop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),tp):GetFirst()
		if sc then
			Duel.ActivateFieldSpell(sc,e,tp,eg,ep,ev,re,r,rp)
		end
	end
end