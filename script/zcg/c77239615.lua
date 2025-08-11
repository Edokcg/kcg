--植物的愤怒 红刺食人花
function c77239615.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239615.spcon)
    e1:SetOperation(c77239615.spop)
    c:RegisterEffect(e1)
	
    --direct attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e2)

    --attack twice
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(2)
    c:RegisterEffect(e3)	
end
function c77239615.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,3,c)
end
function c77239615.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,3,3,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
