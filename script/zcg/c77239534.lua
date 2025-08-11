--女子佣兵 陆虎(ZCG)
function c77239534.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_RELEASE)
    e1:SetCondition(c77239534.reccon)
    e1:SetTarget(c77239534.rectg)
    e1:SetOperation(c77239534.recop)
    c:RegisterEffect(e1)
end
function c77239534.reccon(e,tp,eg,ep,ev,re,r,rp)
    e:SetLabel(e:GetHandler():GetPreviousControler())
    return e:GetHandler():IsReason(REASON_SUMMON)
end
function c77239534.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckEvent(EVENT_SUMMON_SUCCESS) or Duel.CheckEvent(EVENT_MSET)) 
	and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239534.recop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
