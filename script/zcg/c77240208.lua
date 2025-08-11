--传说之心(ZCG)
function c77240208.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77240208.cost)
    e1:SetOperation(c77240208.spop)
    c:RegisterEffect(e1)

    --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c77240208.efilter)
	c:RegisterEffect(e2)
end

function c77240208.sfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end

function c77240208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240208.sfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
    local sg=Duel.GetMatchingGroup(c77240208.sfilter,tp,LOCATION_ONFIELD,0,c)
    Duel.Release(sg,REASON_EFFECT)
end

function c77240208.sfilter1(c,e,tp)
	return c:IsCode(77240202) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240208.sfilter2(c,e,tp)
	return c:IsCode(77240203) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240208.sfilter3(c,e,tp)
	return c:IsCode(77240204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240208.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g1=Duel.SelectMatchingCard(tp,c77240208.sfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g2=Duel.SelectMatchingCard(tp,c77240208.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g3=Duel.SelectMatchingCard(tp,c77240208.sfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
   g1:Merge(g2)
   g1:Merge(g3)
   if g1:GetCount()>0 then
       Duel.SpecialSummon(g1,0,tp,tp,true,true,POS_FACEUP)
   end
   local tc=g1:GetFirst()
   while tc do
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(2000)
	tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e2)
    tc=g1:GetNext()
   end
    local tg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,e:GetHandler())
	Duel.Destroy(tg,REASON_EFFECT)
end

function c77240208.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end