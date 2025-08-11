--植物的愤怒 青藤食人花
function c77239620.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239620.spcon)
    c:RegisterEffect(e1)

    --attack twice
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
--------------------------------------------------------------------
function c77239620.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa90)
end
--[[function c77239620.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239620.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c77239620.spop(e,tp,eg,ep,ev,re,r,rp,c)
    if c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end]]

function c77239620.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c77239620.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end