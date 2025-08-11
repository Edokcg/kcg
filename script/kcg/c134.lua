local s, id = GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x23),10,2)
	c:EnableReviveLimit()

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.setcon2)
	e3:SetValue(s.valfilter)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_DISABLE)
	e6:SetCondition(s.setcon)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)

	--selfdes
	local e201=Effect.CreateEffect(c)
	e201:SetType(EFFECT_TYPE_SINGLE)
	e201:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e201:SetRange(LOCATION_MZONE)
	e201:SetCode(EFFECT_SELF_DESTROY)
	e201:SetCondition(s.descon)
	c:RegisterEffect(e201)
end
s.listed_series={0x23}

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function s.setcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function s.setcon2(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function s.valfilter(e,c)
	return -e:GetHandler():GetAttack()
end
