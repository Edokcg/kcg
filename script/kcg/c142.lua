--被封印的左手 (K)
function c142.initial_effect(c)
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
       e1:SetValue(c142.efilter)
       c:RegisterEffect(e1)
end

function c142.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end