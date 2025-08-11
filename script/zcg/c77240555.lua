--欧贝利斯克之王者降临(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg2)
	e3:SetOperation(s.recop2)
	c:RegisterEffect(e3)
--cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_SZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_SZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_SZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_SZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.filter(c)
	return c:IsCanChangePosition() and c:IsFaceup() and c:IsAttackPos()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	 if rg:GetCount()<0 then return end
	 local tc=rg:GetFirst()
	 while tc do
	   if tc:GetPosition()==POS_FACEUP_ATTACK then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0) end
	   if tc:GetPosition()==POS_FACEUP_DEFENSE then
		tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0) end
	   if tc:GetPosition()==POS_FACEDOWN_DEFENSE then
		tc:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0) end
		tc=rg:GetNext()
	 end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	 if g:GetCount()>0 then
		 local tc=g:GetFirst()
		while tc do
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		tc=g:GetNext()
		end
	end
end
function s.filter2(c)
	return c:IsFaceup() and (c:GetFlagEffect(id)>0 or c:GetFlagEffect(id+1)>0 or c:GetFlagEffect(id+2)>0) and c:IsCanChangePosition()
end
function s.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil)
 if g:GetCount()>0 then
		 local tc=g:GetFirst()
		while tc do
		if tc:GetFlagEffect(id)>0 then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		elseif tc:GetFlagEffect(id+1)>0 then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		elseif tc:GetFlagEffect(id+2)>0 then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
		tc=g:GetNext()
		end
	end
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end


