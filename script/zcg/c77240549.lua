--欧贝利斯克之黑桃熊(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.hdcon)
	e3:SetTarget(s.hdtg)
	e3:SetOperation(s.hdop)
	c:RegisterEffect(e3)
 --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
--cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_MZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_MZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_MZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_MZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)
end
function s.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa220) and c:IsFaceup()
end
function s.spcon(e)
	return Duel.IsExistingMatchingCard(s.spfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end
