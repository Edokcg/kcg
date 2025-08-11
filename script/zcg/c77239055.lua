--空间穿梭
function c77239055.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239055.target)
    e1:SetOperation(c77239055.activate)
    c:RegisterEffect(e1)
end
function c77239055.filter(c,e,tp)
    return c:IsSetCard(0xa13) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77239055.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239055.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c77239055.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239055.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tg=g:GetFirst()
    if tg==nil then return end
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    e1:SetCondition(c77239055.thcon)
    e1:SetOperation(c77239055.thop)
    e1:SetLabel(0)
    tg:RegisterEffect(e1)
end
function c77239055.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239055.thop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    e:GetHandler():SetTurnCounter(ct+1)
    if ct==1 then
        Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
    else e:SetLabel(1) end
end
