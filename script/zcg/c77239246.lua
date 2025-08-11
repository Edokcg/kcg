--奥利哈刚 拷问刑具(ZCG)
function c77239246.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77239246.activate)	
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239246.damtg)
    e2:SetOperation(c77239246.damop)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------------
function c77239246.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_SZONE)	
    e1:SetCountLimit(1)
    e1:SetCondition(c77239246.descon)
    e1:SetOperation(c77239246.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
    e:GetHandler():RegisterEffect(e1)
end
function c77239246.descon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239246.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>=3 then
        Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
    end
end
------------------------------------------------------------------------
function c77239246.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77239246.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local d=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*100
    Duel.Damage(p,d,REASON_EFFECT)
end
