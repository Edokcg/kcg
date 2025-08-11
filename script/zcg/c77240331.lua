--上古邪灵积木(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		 c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.limfilter),LOCATION_SZONE)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(1040)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.lpcon)
	e2:SetOperation(s.lpop) 
	c:RegisterEffect(e2)
   --remain field
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e9)
end
function s.limfilter(c)
return c:IsCode(77240324) or c:IsCode(77240329) or c:IsCode(77240330) or c:IsCode(77240331) or c:IsCode(77240332) or c:IsCode(77240333) or c:IsCode(77240334)
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetLP(tp)<8000
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetLP(tp)<8000 then
		Duel.SetLP(tp,8000)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,5)
	s[e:GetHandler()]=e1
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end