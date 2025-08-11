--DB-孙悟空-茁壮成长
function c77240019.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(16222645,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCondition(c77240019.descon)
    e1:SetTarget(c77240019.destg)
    e1:SetOperation(c77240019.desop)
    c:RegisterEffect(e1)
end
function c77240019.descon(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return e:GetHandler()==Duel.GetAttacker() and d and e:GetHandler():GetAttack()>d:GetAttack()
end
function c77240019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,0,0)
end
function c77240019.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.GetAttackTarget()
    if d:IsRelateToBattle() then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        d:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetValue(RESET_TURN_SET)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        d:RegisterEffect(e3)
        Duel.Destroy(d,REASON_EFFECT)
    end
end
