--仪式的黑魔术师(ZCG)
function c77239988.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239988.spcon)
    e1:SetOperation(c77239988.spop)
    c:RegisterEffect(e1)

    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2)	
	
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c77239988.spcon1)
    e3:SetOperation(c77239988.spop1)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------------------
function c77239988.spfilter(c)
    return (c:IsSetCard(0x10a2) or c:IsSetCard(0x30a2)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c77239988.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239988.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c77239988.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239988.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
-----------------------------------------------------------------------------------
function c77239988.spfilter1(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c77239988.spcon1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239988.spfilter1,tp,LOCATION_GRAVE,0,2,e:GetHandler())
end
function c77239988.spop1(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239988.spfilter1,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end



