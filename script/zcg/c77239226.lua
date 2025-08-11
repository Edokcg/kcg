--奥利哈刚 炎魔象(ZCG)
function c77239226.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,77239226)		
    e1:SetCondition(c77239226.spcon)
    c:RegisterEffect(e1)
end
------------------------------------------------------------------
function c77239226.spfilter(c)
    return c:IsFaceup() and c:IsCode(77239261)
end
function c77239226.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c77239226.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
