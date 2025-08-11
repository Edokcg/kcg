--末日之音 (KA)
local s, id = GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x89)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con5)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.con4)
	e2:SetTarget(s.tfilter)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.con2)
	e3:SetTarget(s.tfilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.con3)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--Add counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(572,0))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.accon)
	e6:SetOperation(s.acop)
	c:RegisterEffect(e6) 
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(s.con1)
	e7:SetValue(s.efilter)
	c:RegisterEffect(e7)
	--selfdes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetCondition(s.descon)
	c:RegisterEffect(e8)   
end

function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x89)>=1
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x89)>=2
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x89)>=3
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x89)>=4
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x89)>=5
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.tfilter(e,c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

function s.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x89,1)
	if e:GetHandler():GetCounter(0x89)>=6 then
		Duel.Win(tp,0x0) 
	end
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.descon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
