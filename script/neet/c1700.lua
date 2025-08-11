--空牙团的勇气 卡利基（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x114),2)
	c:EnableReviveLimit()
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
--To hand
	local e20=Effect.CreateEffect(c)
	e20:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e20:SetCode(EVENT_DESTROYED)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCountLimit(1,{id,1})
	e20:SetCondition(s.spcon)
	e20:SetTarget(s.thtg)
	e20:SetOperation(s.thop)
	c:RegisterEffect(e20)
end
s.listed_series={0x114}
function s.tgfilter(c,ft)
	return  c:IsSetCard(0x114) and c:IsLevelBelow(3) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x114) and c:IsLevelAbove(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		local dt=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #dt>0 then
			local ed=dt:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(ed,0,tp,tp,false,false,POS_FACEUP) 
		end
	end
end
function s.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==1-tp and c:IsSetCard(0x114) and c:IsLevelAbove(4)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.filter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsSetCard(0x114) and c:IsLevelBelow(3) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
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