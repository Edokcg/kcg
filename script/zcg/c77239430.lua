--六芒星碎片(ZCG)
function c77239430.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)	
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239430.condition)	
    e1:SetTarget(c77239430.tg)
    e1:SetOperation(c77239430.op)
    c:RegisterEffect(e1)    
end
----------------------------------------------------------------
function c77239430.cfilter1(c,tp)
    return c:IsSetCard(0xa70) and c:GetPreviousControler()==tp
end
function c77239430.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239430.cfilter1,1,nil,tp)
end
function c77239430.filter(c,e,tp)
    return c:IsSetCard(0xa70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239430.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c77239430.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_HAND)
end
function c77239430.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239430.filter,tp,LOCATION_HAND,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
        end
    end
end
