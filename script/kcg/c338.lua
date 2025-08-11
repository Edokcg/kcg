--Shifting Land (K)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCondition(s.con)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)	
	local e5=e2:Clone()
	e5:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e5)	

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(s.desop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
s.listed_series={0x552,0x503}
s.listed_names={342}

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	  local lp=Duel.GetLP(tp)
	  e:SetLabel(lp)
end

function s.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.filter2(c)
    local code=c:GetRealCode()
	return c:IsFaceup() and (c:IsSetCard(0x552) or c:IsSetCard(0x503) or c:IsCode(347) or code==347)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 and g2:GetCount()>0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tatk=0
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	  local atk=tc:GetAttack()
	  tatk=tatk+atk
	  tc=g:GetNext() end
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetRange(LOCATION_SZONE) 
	  e1:SetTargetRange(1,0)
	  e1:SetValue(0)
	  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	  c:RegisterEffect(e1)
	Duel.SetLP(tp,tatk)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local lp=te:GetLabel()
	  Duel.SetLP(tp,lp)
end

