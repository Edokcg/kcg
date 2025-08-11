--磁石之力
function c123.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(68823957,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCondition(c123.condition)
	e0:SetTarget(c123.target)
	e0:SetOperation(c123.operation3)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68823957,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c123.condition)
	e1:SetTarget(c123.target)
	e1:SetOperation(c123.operation)
	c:RegisterEffect(e1)
end

function c123.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local oe=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local op=oe:GetOperation()
	local ag,ap,av,are,ar,arp=Duel.GetChainEvent(ev)
	local gcount=g:GetCount()
	if gcount<1 or not Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.ChangeChainOperation(ev,function (...)
	for i=1,gcount do
	  Duel.ClearTargetCard()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	  local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	  Duel.SetTargetCard(g2)
	  op(...)
	  g2:Clear()
	end end)
	c:CancelToGrave()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c123.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c123.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_RULE)
end

function c123.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return false end
	return g:IsExists(c123.filter2,1,nil,tp) 
end
function c123.filter2(c,tp) 
	return (c:IsRace(RACE_ROCK) or c:IsRace(RACE_MACHINE)) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c123.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c123.filter3(c,e) 
	return c:IsFaceup() and c:IsRelateToEffect(e) 
end
function c123.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local oe=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local op=oe:GetOperation()
	local ag,ap,av,are,ar,arp=Duel.GetChainEvent(ev)
	if not g or g:GetCount()==0 then return false end
	local gcount=g:GetCount()
	if not Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.ChangeChainOperation(ev,function (...)
	for i=1,gcount do
	  Duel.ClearTargetCard()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	  local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	  Duel.SetTargetCard(g2)
	  op(...)
	  g2:Clear()
	end end)
end
function c123.efilter(c)
	return (c:IsRace(RACE_ROCK) or c:IsRace(RACE_MACHINE)) and c:IsFaceup()
end
function c123.efilter2(e,c)
	return (c:IsRace(RACE_ROCK) or c:IsRace(RACE_MACHINE)) and c:IsFaceup()
end 
