--女子佣兵 水灵
function c77239506.initial_effect(c)	
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)	
    e1:SetCode(EVENT_DAMAGE_STEP_END)
    e1:SetCondition(c77239506.descon)
    e1:SetTarget(c77239506.destg)
    e1:SetOperation(c77239506.desop)
    c:RegisterEffect(e1)

    --battle indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    e2:SetCondition(c77239506.actcon)	
    c:RegisterEffect(e2)
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c77239506.thcon2)
    e3:SetTarget(c77239506.damtg)
    e3:SetOperation(c77239506.damop)
    c:RegisterEffect(e3)	
end
----------------------------------------------------------------
function c77239506.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239506.descon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local b=Duel.GetAttackTarget()
        return e:GetHandler()==Duel.GetAttacker() and a:GetAttack()<b:GetAttack()
end
function c77239506.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetAttackTarget():IsRelateToBattle() end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,Duel.GetAttackTarget(),1,0,0)
end
function c77239506.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local atk1=c:GetAttack()
    local atk2=tc:GetAttack()
    if tc:IsRelateToBattle() then	
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(atk1)
        e1:SetReset(RESET_EVENT+0xfe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK)
        e2:SetValue(atk2)
        e2:SetReset(RESET_EVENT+0xfe0000)
        c:RegisterEffect(e2)
    end
end
----------------------------------------------------------------
function c77239506.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT)
        and c:IsPreviousLocation(LOCATION_MZONE)
end
function c77239506.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local dam=c:GetPreviousAttackOnField()
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239506.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
