--奥利哈刚之城(ZCG)
function c77239245.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1) 	
    e2:SetTarget(c77239245.target)
    e2:SetOperation(c77239245.activate)
    c:RegisterEffect(e2)
	
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c77239245.target1)
    e3:SetOperation(c77239245.operation)
    c:RegisterEffect(e3) 	
end
---------------------------------------------------------------------
function c77239245.filter(c,e,tp)
    return c:IsLevelBelow(4) and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000171) or c:IsCode(170000172))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239245.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239245.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c77239245.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239245.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
---------------------------------------------------------------------
function c77239245.filter1(c,e,tp)
    return c:IsCode(77239230) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239245.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77239245.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239245.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c77239245.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239245.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end