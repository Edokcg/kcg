--借卡(ZCG)
function c77239152.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_SEARCH)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77239152.cost)
    e1:SetTarget(c77239152.target)
    e1:SetOperation(c77239152.activate)
    c:RegisterEffect(e1)
end
--[[function c77239152.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77239152.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()	
    if Duel.Recover(1-tp,1000,REASON_EFFECT) and Duel.Damage(tp,1000,REASON_EFFECT)
	and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)    
        tc:RegisterFlagEffect(77239152,RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetCondition(c77239152.tgcon)
        e1:SetOperation(c77239152.tgop)
        e1:SetLabelObject(tc)
        e1:SetReset(RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)	       
    end  
end]]
function c77239152.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return tc:GetFlagEffect(77239152)~=0
end
function c77239152.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end

function c77239152.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Duel.Recover(1-tp,1000,REASON_EFFECT)
end
function c77239152.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239152.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239152.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239152.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)    
        tc:RegisterFlagEffect(77239152,RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetCondition(c77239152.tgcon)
        e1:SetOperation(c77239152.tgop)
        e1:SetLabelObject(tc)
        e1:SetReset(RESET_EVENT+0x5c0000+RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end