--黑魔導女孩 绿将(ZCG)
function c77239955.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239955.valcon)
    c:RegisterEffect(e1)

    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)	
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)	
    e2:SetCost(c77239955.cost)	
    e2:SetTarget(c77239955.target)
    e2:SetOperation(c77239955.operation)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239955.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239955.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77239955.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function c77239955.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c77239955.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239955.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c77239955.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239955.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetRange(LOCATION_REMOVED)
        e1:SetCountLimit(1)
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
            e1:SetValue(Duel.GetTurnCount())
        else
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
            e1:SetValue(0)
        end
        e1:SetCondition(c77239955.retcon)
        e1:SetOperation(c77239955.retop)
        tc:RegisterEffect(e1)
        Duel.Damage(1-tp,1000,REASON_EFFECT)
    end
end
function c77239955.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetValue()
end
function c77239955.retop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler()
    Duel.ReturnToField(tc)
end