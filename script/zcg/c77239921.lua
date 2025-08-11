--神之奇迹(ZCG)
function c77239921.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)	
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239921.cost)	
    e1:SetTarget(c77239921.sptg1)
    e1:SetOperation(c77239921.spop1)
    c:RegisterEffect(e1)
end
function c77239921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLP(tp)>1 end
    local lp=Duel.GetLP(tp)
    Duel.PayLPCost(tp,lp-1)
end

function c77239921.sfilter1(c,e,tp)
	return c:IsCode(10000000) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.sfilter2(c,e,tp)
	return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.sfilter3(c,e,tp)
	return c:IsCode(10000020) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239921.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239921.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239921.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239921.spop1(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77239921.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c77239921.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,c77239921.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEUP)
end
--[[function c77239921.spfilter1(c,e,tp)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.spfilter2(c,e,tp)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.spfilter3(c,e,tp)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239921.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingTarget(c77239921.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239921.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239921.spfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,c77239921.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c77239921.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g3=Duel.SelectTarget(tp,c77239921.spfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c77239921.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if g:GetCount()>2 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
            local de=Effect.CreateEffect(e:GetHandler())
            de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
            de:SetRange(LOCATION_MZONE)
            de:SetCode(EVENT_PHASE+PHASE_END)
            de:SetCountLimit(1)
            de:SetOperation(c77239921.desop)
            de:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(de,true)
            Duel.SpecialSummonComplete()
            tc=g:GetNext()
        end
    end
end
function c77239921.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(g1,POS_FACEUP,REASON_RULE)
end]]