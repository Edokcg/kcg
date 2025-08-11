--强制的黑暗觉醒(ZCG)
function c77239168.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239168.target)
    c:RegisterEffect(e1)

    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)

    --remain field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e3)
end
function c77239168.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():SetTurnCounter(0)
    local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
    --destroy
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c77239168.descon)
    e1:SetOperation(c77239168.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
    e:GetHandler():RegisterEffect(e1)
    e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
    c77239168[e:GetHandler()]=e1
end
function c77239168.descon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239168.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==3 then
        Duel.Destroy(c,REASON_RULE)
        c:ResetFlagEffect(1082946)
    end
end
