--六芒星天界(ZCG)
function c77239441.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	
	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	
	
	--自爆
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c77239441.descon)
	c:RegisterEffect(e7)
end
function c77239441.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end

function c77239441.descon(e)
	return not Duel.IsExistingMatchingCard(c77239441.filter,e:GetHandler():GetControler(),LOCATION_SZONE,0,1,nil)
end