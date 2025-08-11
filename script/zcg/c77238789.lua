--真红眼长颈龙(ZCG)
function c77238789.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238789,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetTarget(c77238789.eqtg)
    e1:SetOperation(c77238789.eqop)
    c:RegisterEffect(e1)
end
function c77238789.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77238789.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77238789.eqop(e,tp,eg,ep,ev,re,r,rp)
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
        e1:SetValue(c77238789.eqlimit)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetCode(EFFECT_SET_CONTROL)
        e2:SetValue(tp)
        e2:SetReset(RESET_EVENT+0x1fc0000)
        c:RegisterEffect(e2)   
    end
end
