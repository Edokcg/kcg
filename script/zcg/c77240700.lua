--不死之元素英雄 次新宇侠(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(s.subcon)
	c:RegisterEffect(e2)
end
function s.subcon(e)
	return e:GetHandler():IsLocation(0x1e)
end