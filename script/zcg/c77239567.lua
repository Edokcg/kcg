--灵魂对换
function c77239567.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239567.target1)	
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10011,0))	
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c77239567.target)
    e2:SetOperation(c77239567.activate)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------------
function c77239567.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():SetTurnCounter(0)
    --destroy
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c77239567.descon)
    e1:SetOperation(c77239567.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
    e:GetHandler():RegisterEffect(e1)
    e:GetHandler():RegisterFlagEffect(77239567,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function c77239567.descon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239567.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==1 then
        Duel.SendtoGrave(c,REASON_EFFECT)
        c:ResetFlagEffect(77239567)
    end
end
------------------------------------------------------------------------
function c77239567.filter(c)
    return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER)
end
function c77239567.filter1(c)
    return c:IsAbleToHand() and c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER)
end
function c77239567.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239567.filter,tp,LOCATION_HAND,0,1,nil)
    and Duel.IsExistingMatchingCard(c77239567.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	
end
function c77239567.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239567.filter1,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)	
    local g=Duel.SelectMatchingCard(tp,c77239567.filter,tp,LOCATION_HAND,0,1,sg:GetCount(),nil)
    local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	Duel.BreakEffect()
    if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
		local tg=Duel.SelectMatchingCard(tp,c77239567.filter,tp,LOCATION_DECK,0,ct,ct,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)	
	end
end


