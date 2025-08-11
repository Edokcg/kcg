local s,id=GetID()
function s.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)

    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xae))
	e2:SetValue(0x10ae)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf))
	e4:SetValue(0x903)
	c:RegisterEffect(e4)

	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)    
end
s.listed_series = {0x10ae, 0xae, 0x903, 0xaf}

function s.efilter(e,te)
	return te:GetOwnerPlayer()==e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
