--暗黑界的军神王 希尔瓦(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),s.matfilter) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_DARK_WORLD}
function s.matfilter(c,fc,sumtype,tp)
	local lv=c:GetLevel()
	return c:HasLevel() and c:IsSetCard(SET_DARK_WORLD) and (lv==5 or lv==6)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if tc:IsOnField() then return end
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then   
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
		and rp==1-tp and c:IsPreviousControler(tp)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil,1-tp,POS_FACEDOWN,REASON_RULE)
	local dg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT+REASON_DISCARD)
	local max=math.min(#rg,#dg,2)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350) and max>0 end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil,1-tp,POS_FACEDOWN,REASON_RULE)
	local dg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT+REASON_DISCARD)
	local max=math.min(#rg,#dg,2)
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,max,REASON_EFFECT+REASON_DISCARD,nil) 
	if ct>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local g=rg:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil,1-tp,POS_FACEDOWN,REASON_RULE)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE,PLAYER_NONE,1-tp)
	end
end