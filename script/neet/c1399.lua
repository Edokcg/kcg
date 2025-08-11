--忍者魂 上忍(neet)
local s,id=GetID()
function s.initial_effect(c)
	Spirit.AddProcedure(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	Pendulum.AddProcedure(c)   
	--Return from the Pendulum Zone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) end)
	e2:SetTarget(s.disable)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function s.gyfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_PZONE)
end
function s.disable(e,c)
	return c:GetColumnGroup():IsExists(s.gyfilter,1,nil,e:GetHandlerPlayer())
end
function s.cfilter(c,seq,p)
	return c:IsFaceup() and c:IsColumn(seq,p,LOCATION_PZONE)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) then return false end
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_PZONE,0,1,nil,seq,p)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end