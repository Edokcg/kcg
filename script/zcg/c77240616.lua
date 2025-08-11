--殉道者之腐朽的更替(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
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
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,nil)
	if #g==#g2 then
		Duel.SwapControl(g,g2)
	elseif #g>#g2 then
		local tc=g:GetFirst()
		local tc2=g2:GetFirst()
		while tc2 do
			Duel.SwapControl(tc,tc2)
		tc=g:GetNext()
		tc2=g2:GetNext()
		end
		while tc do
		 Duel.GetControl(tc,1-tp)
		 tc=g:GetNext()
		end
	else
		local tc=g:GetFirst()
		local tc2=g2:GetFirst()
		while tc do
			Duel.SwapControl(tc,tc2)
		tc=g:GetNext()
		tc2=g2:GetNext()
		end
		while tc2 do
		 Duel.GetControl(tc2,tp)
		 tc2=g2:GetNext()
		end
	end
end
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end 
--[[
	DiyBy神数不神 
	2022-8-9
  ]]