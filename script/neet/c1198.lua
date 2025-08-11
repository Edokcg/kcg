--妖精传姬-塞壬(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	-- Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_SPELLCASTER),2,2)   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==2
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.filter(c)
	return c:GetAttack()==1850 and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and #eg==1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	local g=eg:Clone()
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	if c:IsFaceup() and tc:IsFaceup() then
	   c:SetCardTarget(tc)
	   --Cannot attack
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CANNOT_ATTACK)
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	   e1:SetCondition(function(e) return c:IsHasCardTarget(tc)  end)
	   c:RegisterEffect(e1,true)
	   --Negate their effects
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_DISABLE)
	   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	   e2:SetCondition(function(e) return c:IsHasCardTarget(tc)  end)
	   c:RegisterEffect(e2,true)
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_DISABLE_EFFECT)
	   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	   e3:SetCondition(function(e) return c:IsHasCardTarget(tc)  end)
	   c:RegisterEffect(e3,true)
	   Duel.SpecialSummonComplete()
	end
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	   e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
	   e4:SetValue(LOCATION_REMOVED)
	   c:RegisterEffect(e4,true)
end