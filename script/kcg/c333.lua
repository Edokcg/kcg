--壓力Desmosome (K)
function c333.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetValue(c333.atkval)
    c:RegisterEffect(e4)
end

function c333.atkval(e,c)
    return Duel.GetLP(1-c:GetControler())/2
end