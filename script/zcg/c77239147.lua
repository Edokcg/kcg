--青眼的究极龙
function c77239147.initial_effect(c)
    c:EnableReviveLimit()	
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239147.spcon)
    e1:SetOperation(c77239147.spop)	
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------
function c77239147.spfilter(c)
    return c:IsFaceup() and c:IsCode(77239135)
end
function c77239147.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239147.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
function c77239147.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,300)
end

