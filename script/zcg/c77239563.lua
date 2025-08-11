--姐妹同心(ZCG)
function c77239563.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239563.condition)
    e1:SetTarget(c77239563.tg)
    e1:SetOperation(c77239563.op)
    c:RegisterEffect(e1)
end
---------------------------------------------------------------------------------
function c77239563.cfilter1(c,tp)
    return c:IsSetCard(0xa80) and c:GetPreviousControler()==tp
end
function c77239563.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239563.cfilter1,1,nil,tp)
end
--[[function c77239563.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local code=eg:GetFirst():GetCode()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239563.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,code,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c77239563.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local code=eg:GetFirst():GetCode()
    local tc2=Duel.GetFirstMatchingCard(c77239563.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,code,e,tp)
    if tc2 and Duel.SpecialSummon(tc2,0,tp,tp,true,false,POS_FACEUP)~=0 then
        tc2:CompleteProcedure()
    end
end]]
function c77239563.filter2(c,e,tp)
	return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239563.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77239563.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239563.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239563.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
        Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
end