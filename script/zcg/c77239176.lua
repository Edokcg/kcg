--神魂龙(ZCG)
function c77239176.initial_effect(c)
    --battle indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	
    --battle target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ONLY_BE_ATTACKED)
    c:RegisterEffect(e2)	
end
