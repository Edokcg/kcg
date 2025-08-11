--六芒星的水祭(ZCG)
function c77239432.initial_effect(c)
    --[[activate
    local e1=Effect.CreateEffect(c)	
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCondition(c77239432.condition)	
    e1:SetTarget(c77239432.tg)
    e1:SetOperation(c77239432.op)
    c:RegisterEffect(e1)]]
	
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c77239432.condition)
    e1:SetTarget(c77239432.target)
    e1:SetOperation(c77239432.operation)
    c:RegisterEffect(e1)
end
----------------------------------------------------------------
--[[function c77239432.cfilter1(c,tp)
    return c:GetPreviousControler()==tp
end
function c77239432.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239432.cfilter1,1,nil,tp)
end
function c77239432.filter(c,e,tp)
    return c:IsCode(77239406) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239432.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and  Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c77239432.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c77239432.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.SendtoGrave(tc,REASON_EFFECT) then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c77239432.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end]]
function c77239432.filter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY+REASON_BATTLE) and c:IsSetCard(0xa70)
end
function c77239432.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239432.filter,1,nil,tp)
end
function c77239432.spfilter(c,e,tp)
    return c:IsCode(77239406) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239432.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239432.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
end
function c77239432.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
	if Duel.SendtoGrave(tc,REASON_EFFECT) then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239432.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()~=0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		end
    end
end