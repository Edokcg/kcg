--六芒星 龙狂士(ZCG)
function c77239419.initial_effect(c)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239419.spcon)
    e1:SetOperation(c77239419.spop)
    c:RegisterEffect(e1)

    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(c77239419.indval)
    c:RegisterEffect(e2)	
	
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239419.cost)	
    e3:SetTarget(c77239419.sptg)
    e3:SetOperation(c77239419.spop1)
    c:RegisterEffect(e3)
end
---------------------------------------------------------------------------
function c77239419.spfilter(c)
    return c:IsType(TYPE_SPELL)
end
function c77239419.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239419.spfilter,tp,LOCATION_SZONE,0,1,nil,c)
end
function c77239419.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)	
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-1450)
    e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
    e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetValue(-1000)
    c:RegisterEffect(e2)
end
---------------------------------------------------------------------------
function c77239419.indval(e,re,rp)
    return re:IsActiveType(TYPE_SPELL)
end
---------------------------------------------------------------------------
function c77239419.filter(c,e,tp)
    return c:IsSetCard(0xa70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239419.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
    local tc=sg:GetFirst()
    Duel.Release(tc,REASON_COST)
end
function c77239419.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239419.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239419.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239419.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end