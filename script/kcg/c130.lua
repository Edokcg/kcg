--被封印的左腳 (K)
function c130.initial_effect(c)
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
       e1:SetValue(c130.efilter)
       c:RegisterEffect(e1)
end

function c130.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end