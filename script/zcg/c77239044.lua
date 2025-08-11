--夹皮王
function c77239044.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77239044.val)
	c:RegisterEffect(e1)
end
function c77239044.val(e,c)
	return Duel.GetMatchingGroupCount(c77239044.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c77239044.filter(c)
	return c:IsRace(RACE_WARRIOR+RACE_BEASTWARRIOR)
end
