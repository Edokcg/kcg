--神石板 强势回击(ZCG)
function c77239097.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCondition(c77239097.condition)
    e1:SetTarget(c77239097.target)
    e1:SetOperation(c77239097.activate)
    c:RegisterEffect(e1)
end
function c77239097.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
        and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0xa20)
end
function c77239097.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239097.cfilter,1,nil,tp)
end
function c77239097.filter(c,e,tp)
    return c:IsSetCard(0xa20) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--[[function c77239097.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239097.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239097.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239097.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
        if g2:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=g2:Select(tp,1,2,nil)
            Duel.Destroy(sg,REASON_EFFECT)
        end
    end
end]]

function c77239097.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239097.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77239097.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77239097.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239097.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
        if g2:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=g2:Select(tp,1,2,nil)
            Duel.Destroy(sg,REASON_EFFECT)
        end
	end
end