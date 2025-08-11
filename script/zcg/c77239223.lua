--奥利哈刚 极思克(ZCG)
function c77239223.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239223.target)
    e1:SetOperation(c77239223.operation)
    c:RegisterEffect(e1) 
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2) 
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3) 	
	
    --deckdes
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DECKDES)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetTarget(c77239223.detg)
    e4:SetCondition(c77239223.decon)
    e4:SetOperation(c77239223.deop)
    c:RegisterEffect(e4)
end
---------------------------------------------------------------------------
function c77239223.filter(c,e,tp)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsControler(tp)
end
function c77239223.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and c77239223.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c77239223.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239223.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77239223.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
---------------------------------------------------------------------------
function c77239223.detg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function c77239223.deop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end
function c77239223.decon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP)
end
