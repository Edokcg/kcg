--六芒星 龙武士(ZCG)
function c77239418.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239418.spcon)
    e1:SetOperation(c77239418.spop)	
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239418.cost)	
    e2:SetTarget(c77239418.sptg)
    e2:SetOperation(c77239418.spop1)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------------
function c77239418.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c77239418.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)	
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-1500)
    e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
    e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetValue(-1000)
    c:RegisterEffect(e2)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239418.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end	
end
function c77239418.filter(c)
    return c:IsSetCard(0xa70) and c:IsAbleToHand()
end
-------------------------------------------------------------------
function c77239418.filter1(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239418.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c77239418.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239418.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239418.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239418.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
	    local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        tc:RegisterEffect(e1)
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end