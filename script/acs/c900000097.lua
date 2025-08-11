--冥界之石板
function c900000097.initial_effect(c)
	
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--场上的千年神器不会被效果破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c900000097.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--效果不会被无效化
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000097.target(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2222)
end
