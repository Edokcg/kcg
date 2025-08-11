--上古恶灵眼(ZCG)
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
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
  --
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.acon)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
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
function s.acon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(1-tp,id)>0 and Duel.GetActivityCount(1-tp,ACTIVITY_ATTACK)==0) or (Duel.GetFlagEffect(1-tp,id+1)>0 and Duel.GetActivityCount(1-tp,ACTIVITY_ATTACK)>0)  then
	Duel.ResetFlagEffect(1-tp,id)
	Duel.ResetFlagEffect(1-tp,id+1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_TURN)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1,tp)
end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	opt=Duel.SelectOption(1-tp,aux.Stringid(id,0),aux.Stringid(id,1))
	if opt==0 then
	  Duel.RegisterFlagEffect(1-tp,id,0,0,1)
	else
	  Duel.RegisterFlagEffect(1-tp,id+1,0,0,1)
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
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
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
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end
