--地缚之伪灵(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(function(e,c) return c:IsSetCard(SET_EARTHBOUND_IMMORTAL) end)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(s.drcon)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end
s.listed_names={44710391}
s.listed_series={SET_EARTHBOUND_IMMORTAL}
function s.spcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,44710391),tp,LOCATION_FZONE,0,1,nil)
end
function s.filter(c)
	return c:IsSetCard(SET_EARTHBOUND_IMMORTAL) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SUMMON and e:GetHandler():GetReasonCard():IsSetCard(SET_EARTHBOUND_IMMORTAL)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>=1 then return end
	local ct=1
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then 
		ct=2
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,0,ct)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e2,tp)
end