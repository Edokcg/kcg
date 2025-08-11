--六芒星龙斗哈钢(ZCG)
function c77239443.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239443.target)
    c:RegisterEffect(e1)
    --forbidden
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_FORBIDDEN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0x7f,0x7f)
    e2:SetTarget(c77239443.bantg)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
end
function c77239443.bantg(e,c)
    return c:IsSetCard(0xa50)
end

function c77239443.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():SetTurnCounter(0)
 
    --destroy
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c77239443.descon)
    e1:SetOperation(c77239443.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,10)
    e:GetHandler():RegisterEffect(e1)
    e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,10)
    c77239443[e:GetHandler()]=e1
end
function c77239443.descon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239443.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>=10 then
        Duel.Destroy(c,REASON_RULE)
        c:ResetFlagEffect(1082946)
    end
end