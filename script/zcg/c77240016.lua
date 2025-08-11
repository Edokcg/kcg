--DB-孙悟空-龟派气功
function c77240016.initial_effect(c)
    --Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10114004,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(aux.bdocon)
    e3:SetTarget(c77240016.destg)
    e3:SetOperation(c77240016.desop)
    c:RegisterEffect(e3)  
end
function c77240016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsFacedown() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77240016.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end