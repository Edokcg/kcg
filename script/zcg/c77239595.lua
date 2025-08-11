--恶魔的灵魂
function c77239595.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239595,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetTarget(c77239595.eqtg)
    e1:SetOperation(c77239595.eqop)
    c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239595.spcon)
    e2:SetOperation(c77239595.spop)
    c:RegisterEffect(e2)
end
--------------------------------------------------------------
function c77239595.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c77239595.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239595.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c77239595.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239595.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--------------------------------------------------------------
function c77239595.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239595.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77239595.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.Equip(tp,c,tc,true)
        --Add Equip limit
        local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239595.eqlimit)
        c:RegisterEffect(e1)
        c:SetCardTarget(tc)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_CONTROL)
        e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(tp)
        e2:SetLabel(0)
        e2:SetReset(RESET_EVENT+0x1fc0000)
        e2:SetCondition(c77239595.ctcon)
        tc:RegisterEffect(e2)
    end
end
function c77239595.ctcon(e)
    local c=e:GetOwner()
    local h=e:GetHandler()
    return c:IsHasCardTarget(h)
end
