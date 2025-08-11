--DB-孙悟空-勇往直前
function c77240018.initial_effect(c)
    --summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77240018.spop)
    c:RegisterEffect(e1)
	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_REFLECT_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,0)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c77240018.spop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():SetTurnCounter(0)
    --destroy
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c77240018.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
    e:GetHandler():RegisterEffect(e1)
    e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,3)
    c77240018[e:GetHandler()]=e1	
end
function c77240018.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==3 then
        Duel.SendtoGrave(c,REASON_EFFECT)
        c:ResetFlagEffect(1082946)
    end
end