--地缚神 憎(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --unique
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
end
