--只有两个人的方舟(ZCG)
function c77239684.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239684.target)
    e1:SetOperation(c77239684.activate)
    c:RegisterEffect(e1)
end
function c77239684.filter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsFaceup()
end
function c77239684.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(c77239684.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c77239684.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77239684.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
		--tohand
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
        e2:SetCode(EVENT_BATTLE_DESTROYING)
        e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
        e2:SetRange(LOCATION_MZONE)
	    e2:SetCondition(c77239684.thcon)	
        e2:SetTarget(c77239684.thtg)
        e2:SetOperation(c77239684.thop)
        tc:RegisterEffect(e2)	
    end
end
function c77239684.thcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    local bc=ec:GetBattleTarget()
    return e:GetHandler()==ec and ec:IsControler(tp)
        and bc:IsReason(REASON_BATTLE) and bc:GetPreviousControler()~=tp
end
function c77239684.thfilter(c)
    return c:IsCode(77239684) and c:IsAbleToHand()
end
function c77239684.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239684.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239684.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239684.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end