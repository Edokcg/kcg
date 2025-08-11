--奥利哈刚 万蛇灵(ZCG)
function c77239236.initial_effect(c)	
    --特殊召唤
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239236.spcost)	
    e3:SetTarget(c77239236.sptg)
    e3:SetOperation(c77239236.spop)
    c:RegisterEffect(e3) 
end
----------------------------------------------------------------------------
function c77239236.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c77239236.spfilter(c,e,tp)
    return c:IsCode(77239235) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239236.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239236.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239236.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    Duel.Remove(c,POS_FACEUP,REASON_EFFECT)	
end

