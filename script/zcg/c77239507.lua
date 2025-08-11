--女子佣兵 火灵(ZCG)
function c77239507.initial_effect(c)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c77239507.negcon1)
    e2:SetOperation(c77239507.negop1)
    c:RegisterEffect(e2)

	--dam
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)	
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c77239507.negcon)
    e3:SetTarget(c77239507.damtg)
    e3:SetOperation(c77239507.damop)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------
function c77239507.negcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.GetAttackTarget()
    return e:GetHandler()==Duel.GetAttacker() and c:GetAttack()>d:GetAttack()
end
function c77239507.negop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.GetAttackTarget()
    local def=c:GetDefense()	
    if d~=nil then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(def)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        d:RegisterEffect(e1)	
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e2:SetValue(1)
        d:RegisterEffect(e2,true)
    end
end
--------------------------------------------------------------
function c77239507.negcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker()
end
function c77239507.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local t=Duel.GetAttackTarget()
    if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() end
    local dam=Duel.GetAttackTarget():GetDefense()	
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239507.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
