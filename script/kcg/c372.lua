--Parallel Material
function c372.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c372.target)
	e1:SetOperation(c372.activate)
	c:RegisterEffect(e1)
end

function c372.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x505)
	  --and Duel.IsExistingMatchingCard(c372.filter1,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp,c) 
end
function c372.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c372.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function c372.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c372.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
	if tc then
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(511001225)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	end
	tc=g:GetNext() end
end