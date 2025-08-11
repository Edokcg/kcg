--黑羽-顺风之赛克罗(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	-- Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_BLACKWING),2,2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(s.handcon)
	e1:SetValue(s.handvalue)
	c:RegisterEffect(e1)
	--Trap cards can be activated from the hand
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--Activation cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.costtg)
	e4:SetOperation(s.costop)
	c:RegisterEffect(e4)
end
s.listed_series={SET_BLACKWING}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_BLACKWING) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<ct then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,ct,ct,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_MATERIAL)
            e3:SetValue(aux.cannotmatfilter(SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
			tc:RegisterEffect(e3,true)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_BLACKWING)
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return Duel.IsTurnPlayer(1-tp) and
	 #g>0 and g:FilterCount(aux.FaceupFilter(Card.IsSetCard,SET_BLACKWING),nil)==#g and Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)==3
	 and e:GetHandler():IsAbleToRemove()
end
function s.handvalue(e,rc,re)
	re:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,0,e:GetHandler():GetFieldID())
end
function s.costtg(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and tc:IsLocation(LOCATION_HAND) and tc:HasFlagEffect(id) and tc:GetFlagEffectLabel(id)==e:GetHandler():GetFieldID()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end