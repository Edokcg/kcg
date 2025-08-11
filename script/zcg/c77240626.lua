--殉道者 诡异南瓜布偶(ZCG)
local s,id=GetID()
function s.initial_effect(c)
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
	 --selfdes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_SELF_DESTROY)
	e0:SetCondition(s.descon)
	c:RegisterEffect(e0)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.dam=0
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_BATTLE and ((ep==1-tp and Duel.GetAttackTarget()==e:GetHandler()) or (ep==tp and Duel.GetAttacker()==e:GetHandler()))
end
function s.filter(c)
	return c:IsSetCard(0xa60) and c:IsAbleToGrave()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	s.dam=s.dam+ev
	if s.dam>=3000 then
		s.dam=0
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			local ct=Duel.SendtoGrave(g,REASON_EFFECT)
			local dg=Duel.GetOperatedGroup()
			if dg then
				local dam=dg:GetSum(Card.GetAttack)
				Duel.Damage(1-tp,dam,REASON_EFFECT) 
			end
end
end
end
function s.descon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) 
end
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end 

--[[
	DiyBy神数不神 
	2022-8-10 
  ]]