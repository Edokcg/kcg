--Parallel Material
local s,id=GetID()
function s.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(720147,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x14b}

function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x14b)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	  local tc=g:GetFirst()
	  while tc do
	if tc then
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(511001225)
	e2:SetValue(2)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2,false,4)
	end
	  tc=g:GetNext() end
end