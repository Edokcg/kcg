--Strain Nuke (K)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_OVERLAY)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)	
end
s.listed_names={347}

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=eg:GetFirst()
	-- Duel.Hint(HINT_CARD,ep,331)
	if not eqc then return end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.tar)
	e4:SetCondition(s.condition2)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	eqc:RegisterEffect(e4)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and c:GetOverlayGroup():IsContains(e:GetOwner())
end
function s.tar(e,c)
	local code=e:GetHandler():GetOriginalCode()
	local realcode,ocode,realalias=c:GetRealCode()
	return realcode>0 and ocode==code
end