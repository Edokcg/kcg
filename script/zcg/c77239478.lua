--千年玄武
function c77239478.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --ng
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239478,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCategory(CATEGORY_NEGATE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c77239478.negcon)
    e3:SetTarget(c77239478.negtg)
    e3:SetOperation(c77239478.negop)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------------
function c77239478.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c77239478.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77239478.repfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c77239478.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end	
end
function c77239478.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
		local tc=eg:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e1:SetCondition(c77239478.thcon)
        e1:SetOperation(c77239478.thop)
        e1:SetLabelObject(tc)
        Duel.RegisterEffect(e1,tp)
    end
end
function c77239478.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239478.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
end



