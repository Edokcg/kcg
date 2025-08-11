--殉道者之守望(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(1040)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.wincon)
	e4:SetOperation(s.winop)
	c:RegisterEffect(e4)
--coin
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(s.reop)
	c:RegisterEffect(e5)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(s.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e12:SetTarget(s.distg9)
	c:RegisterEffect(e12)
end
s.restable=0
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end 
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	s.restable=0
end
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	return s.restable and s.restable>=5
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(e:GetHandlerPlayer(),0x11)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	return ex and rp==tp
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.effcon)
	e1:SetOperation(s.effop)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	c:RegisterEffect(e1)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local res={Duel.GetCoinResult()}
	for i=1,ev do
		if res[i]~=0 then
			s.restable=s.restable+1
		end
	end
end