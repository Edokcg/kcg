--殉道者之天降等级（ZCG）
function c77240220.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240220,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c77240220.target)
	e1:SetOperation(c77240220.activate)
	c:RegisterEffect(e1)
  --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240220,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c77240220.target2)
	e2:SetOperation(c77240220.activate2)
	c:RegisterEffect(e2)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240220.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240220.distg9)
	c:RegisterEffect(e12)
end
function c77240220.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240220.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240220.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240220.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end
function c77240220.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77240220.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	local tc=g:GetFirst()
	while tc do
	if tc:IsLevel(1) or tc:IsLevel(2) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	 else  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
end
	end
end
function c77240220.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240220.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240220.filter,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,1,nil) end
end
function c77240220.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77240220.filter,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
	  if tc:IsLevel(12) or tc:IsLevel(11) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(12)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	 else  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	end
end