--黑暗之眼
function c77239023.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e1)
	
	--持续公开手牌
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCondition(c77239023.condition)	
	c:RegisterEffect(e2)	
end
function c77239023.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239023.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239023.filter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
end