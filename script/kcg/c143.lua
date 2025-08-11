--被封印的右腳 (K)
function c143.initial_effect(c)
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
       e1:SetValue(c143.efilter)
       c:RegisterEffect(e1)
end

function c143.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
