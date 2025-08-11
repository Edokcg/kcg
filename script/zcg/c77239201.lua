--奧雷卡爾克斯蕾歐絲 (KA)
function c77239201.initial_effect(c)
    --跳过阶段
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(aux.bdocon)
    e1:SetOperation(c77239201.skipop)
    c:RegisterEffect(e1)  
	
    --贯穿伤害
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
	
    --特殊召唤
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239201.spcost)	
    e3:SetTarget(c77239201.sptg)
    e3:SetOperation(c77239201.spop)
    c:RegisterEffect(e3) 
end
----------------------------------------------------------------------------
function c77239201.skipop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetCode(EFFECT_SKIP_M1) 
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
end
----------------------------------------------------------------------------
function c77239201.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c77239201.spfilter(c,e,tp)
    return c:IsCode(77239204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239201.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239201.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239201.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
end

