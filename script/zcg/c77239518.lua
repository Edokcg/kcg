--女子佣兵 机控者
function c77239518.initial_effect(c)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239518,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)	
    e2:SetCondition(c77239518.negcon)
    e2:SetCost(c77239518.negcost)
    e2:SetTarget(c77239518.negtg)
    e2:SetOperation(c77239518.negop)
    c:RegisterEffect(e2)
end
--------------------------------------------------------------
function c77239518.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xa80) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c77239518.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77239518.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev) and ep~=tp 
end
function c77239518.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c77239518.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77239518.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoGrave(eg,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
        e1:SetCondition(c77239518.spcon)
        e1:SetOperation(c77239518.spop)
        c:RegisterEffect(e1)
    end
end
function c77239518.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239518.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end