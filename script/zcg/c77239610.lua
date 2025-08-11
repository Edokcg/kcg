--植物的愤怒 魔巨树
function c77239610.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239610.spcon)
    e1:SetOperation(c77239610.spop)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------
function c77239610.spfilter(c)
    return c:IsCode(77239611) and c:IsAbleToRemoveAsCost()
end
function c77239610.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239610.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c77239610.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,c77239610.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
--------------------------------------------------------------------



