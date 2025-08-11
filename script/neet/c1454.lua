--核成搬运员(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Add a card to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(s.atkcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetValue(s.repval)
	c:RegisterEffect(e3)
end
s.listed_series={0x1d}
s.listed_names={36623431,id}
function s.thfilter(c)
	return c:IsAbleToHand() and not c:IsCode(id) and (c:IsCode(36623431) or c:ListsCode(36623431))
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
function s.atkcon(e)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x1d),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function s.rfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1d) and not c:IsReason(REASON_REPLACE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and eg:IsExists(s.rfilter,1,e:GetHandler()) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Destroy(c,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function s.repval(e,c)
	return c:IsFaceup() and c:IsSetCard(0x1d) and c~=e:GetHandler()
end