--黑暗大法师 魔神火焰炮
function c77239678.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239678.spcon)
    e1:SetOperation(c77239678.spop)
    c:RegisterEffect(e1)
	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(c77239678.actcon)	
    e2:SetValue(c77239678.efilter)
    c:RegisterEffect(e2)	
	
    --pierce
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e3)

    --redirect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
    e4:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e4)
end
--------------------------------------------------------------------------
function c77239678.spfilter(c,code)
    return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c77239678.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239678.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,7902349)
        and Duel.IsExistingMatchingCard(c77239678.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,8124921)
        and Duel.IsExistingMatchingCard(c77239678.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,33396948)
        and Duel.IsExistingMatchingCard(c77239678.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,44519536)
        and Duel.IsExistingMatchingCard(c77239678.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,70903634)		
end
function c77239678.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239678.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,7902349)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)	
	local g1=Duel.SelectMatchingCard(tp,c77239678.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,8124921)    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c77239678.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,33396948)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c77239678.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,44519536)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c77239678.spfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,70903634)
    g:Merge(g1)
    g:Merge(g2)
    g:Merge(g3)
    g:Merge(g4)	
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--------------------------------------------------------------------------
function c77239678.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239678.efilter(e,te)
    return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--------------------------------------------------------------------------

