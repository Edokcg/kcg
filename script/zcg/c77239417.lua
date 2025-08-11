--六芒星 龙斗士(ZCG)
function c77239417.initial_effect(c)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239417.spcon)
    e1:SetOperation(c77239417.spop)
    c:RegisterEffect(e1)

    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(c77239417.indval)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------------
function c77239417.spfilter(c)
    return c:IsType(TYPE_TRAP)
end
function c77239417.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239417.spfilter,tp,LOCATION_SZONE,0,1,nil,c)
end
function c77239417.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)	
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-1300)
    e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
    e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetValue(-1300)
    c:RegisterEffect(e2)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239417.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end	
end
function c77239417.filter(c)
    return c:IsCode(77239420) and c:IsAbleToHand()
end
---------------------------------------------------------------------------
function c77239417.indval(e,re,rp)
    return re:IsActiveType(TYPE_TRAP)
end