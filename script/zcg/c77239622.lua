--植物的愤怒 白松人
function c77239622.initial_effect(c)
    --[[special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239622,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(aux.bdgcon)
    e1:SetTarget(c77239622.target)
    e1:SetOperation(c77239622.operation)
    c:RegisterEffect(e1)]]
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetTarget(c77239622.target)
    e1:SetOperation(c77239622.operation)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239622,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetCondition(c77239622.condition)
    e2:SetTarget(c77239622.target)
    e2:SetOperation(c77239622.operation)
    c:RegisterEffect(e2)	
end
function c77239622.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
--[[function c77239622.filter(c,e,tp)
    return c:IsSetCard(0xa90) and c:IsAttackBelow(1800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239622.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c77239622.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239622.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239622.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end]]

function c77239622.filter(c,e,tp)
    return c:IsSetCard(0xa90) and c:IsAttackBelow(1800) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239622.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239622.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239622.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239622.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()   
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end