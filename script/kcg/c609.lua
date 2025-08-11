--コストダウン
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x14b}

function s.hlvfilter2(c,tp)
	local f=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return c:IsAbleToDeckAsCost() and (f==nil or (f~=nil and f~=c))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.hlvfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.hlvfilter2,tp,LOCATION_ONFIELD,0,e:GetHandler(),tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(s.hlvfilter,tp,LOCATION_HAND,0,nil)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-10)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(s.hlvop)
	Duel.RegisterEffect(e2,tp)
end
function s.hlvfilter(c,tp)
	return c:IsLevelAbove(10) and c:IsControler(tp) and c:IsSetCard(0x14b)
end
function s.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(s.hlvfilter,nil,tp)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-10)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
