--神之欧贝利斯克的巨神龙
function c77239916.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239916.spcon)
    e1:SetOperation(c77239916.spop)
    c:RegisterEffect(e1)

    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c77239916.sumsuc)
    c:RegisterEffect(e2)	

    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239916,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c77239916.condition)
    e3:SetTarget(c77239916.target)
    e3:SetOperation(c77239916.operation)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239916.spfilter(c)
    return c:IsCode(10000000) and c:IsAbleToGraveAsCost()
end
function c77239916.spfilter1(c)
    return c:IsCode(10000010) and c:IsAbleToGraveAsCost()
end
function c77239916.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239916.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77239916.spfilter1,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
end
function c77239916.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239916.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c77239916.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    g:Merge(g1)
    Duel.SendtoGrave(g,REASON_COST)	
end
------------------------------------------------------------------
function c77239916.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
    if Duel.CheckLPCost(tp,1000) then
        Duel.PayLPCost(tp,1000)
        local atk=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0)*2000
	    --atk/def
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        c:RegisterEffect(e1)		
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
        e3:SetCategory(CATEGORY_ATKCHANGE)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetRange(LOCATION_MZONE)		
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e3:SetCountLimit(1)		
        e3:SetOperation(c77239916.tgop)
        c:RegisterEffect(e3)
    end		
end
function c77239916.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(4000)
    c:RegisterEffect(e1)		
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77239916.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c77239916.filter(c,e,tp)
    return c:IsCode(10000000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77239916.filter1(c,e,tp)
    return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function c77239916.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77239916.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c77239916.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c77239916.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239916.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c77239916.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)   
    g:Merge(g1)
    if g:GetCount()>1 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
