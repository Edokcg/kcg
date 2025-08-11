--三幻神连体
function c77239929.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c77239929.spcon)
    e2:SetOperation(c77239929.spop)
    c:RegisterEffect(e2)
	
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e3:SetTarget(c77239929.disable)
    e3:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e3)
	
    --win
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c77239929.winop)
    c:RegisterEffect(e5)	
end
----------------------------------------------------------------------
function c77239929.cfilter(c,code)
    return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c77239929.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
        and Duel.IsExistingMatchingCard(c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,10000000)
        and Duel.IsExistingMatchingCard(c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,10000010)
        and Duel.IsExistingMatchingCard(c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,10000020)
end
function c77239929.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,10000000)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,10000010)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c77239929.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,10000020)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SendtoGrave(g1,REASON_COST)
end
----------------------------------------------------------------------
function c77239929.disable(e,c)
    return c~=e:GetHandler()
end
----------------------------------------------------------------------
function c77239929.winop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(tp,0x20)
end

