local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3134857,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_series = {0x14b}
s.listed_names={41418852}

function s.filter1(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetOperation(s.activate)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,0)
end

function s.filter(c)
	return c:IsSetCard(0x14b) and c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and c:GetTurnID()==Duel.GetTurnCount() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end