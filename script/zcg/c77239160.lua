--迅捷鼯鼠
function c77239160.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239160.tg)
    e1:SetOperation(c77239160.op)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
    --code
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED)
    e2:SetValue(22567609)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------
function c77239160.filter(c,e,tp)
    return (c:IsCode(77239160) or c:IsCode(22567609)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c77239160.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c77239160.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    if ft<=0 then return end
    if Duel.IsExistingMatchingCard(c77239160.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	and Duel.SelectYesNo(tp,aux.Stringid(77239160,0)) then	
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c77239160.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        end
	end
end