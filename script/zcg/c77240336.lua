--卡通沉默剑士(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 c:EnableCounterPermit(0x1)
--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.addct)
	e1:SetOperation(s.addc)
	c:RegisterEffect(e1)
 --add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.accon)
	e0:SetOperation(s.acop)
	c:RegisterEffect(e0)
	local e2=e0:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	c:RegisterEffect(e2)
--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(s.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
   --Negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(s.condition)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainNegatable(ev) and e:GetHandler():GetCounter(0x1)>=5
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	   Duel.Destroy(eg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function s.efilter(e,te)
	if e:GetHandler():GetCounter(0x1)==2 then
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
	if e:GetHandler():GetCounter(0x1)==3 then
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
	if e:GetHandler():GetCounter(0x1)>=4 then
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
end
function s.indcon(e)
	return e:GetHandler():GetCounter(0x1)>=1
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetHandler():GetControler() and eg:Filter(Card.IsSetCard,nil,0x62):GetCount()>0
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x1,1)
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,1)
	end
end