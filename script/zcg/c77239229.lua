--奥利哈刚 奇甲卡拉(ZCG)
function c77239229.initial_effect(c)
    --direct atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e1)
    --immue a
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c77239229.tg)
    e2:SetValue(c77239229.efilter)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------------------
function c77239229.tg(e,c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239229.efilter(e,te)
    return te:GetHandler():GetControler()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end

