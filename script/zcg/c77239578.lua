--鬼技师
function c77239578.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239578,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c77239578.spcon)
    e1:SetTarget(c77239578.sptg)
    e1:SetOperation(c77239578.spop)
    c:RegisterEffect(e1)
end

function c77239578.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end

--[[function c77239578.spcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,0x4040)==0x4040
end]]
function c77239578.filter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239578.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c77239578.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239578.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239578.filter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end
