--魂气激增(ZCG)
function c77239573.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)	
    e1:SetTarget(c77239573.target)
    e1:SetOperation(c77239573.activate)
    c:RegisterEffect(e1)
end
function c77239573.filter(c)
    return c:IsAbleToGrave()
end
function c77239573.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239573.filter,tp,LOCATION_MZONE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c77239573.filter,tp,LOCATION_MZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c77239573.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239573.filter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()	
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
	    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
        end
        e1:SetCountLimit(1)
        e1:SetCondition(c77239573.spcon2)
        e1:SetOperation(c77239573.spop2)
        tc:RegisterEffect(e1)
        tc:SetTurnCounter(0)	
    end
end
function c77239573.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239573.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==1 then
        Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(c:GetAttack()*2)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
    end
end