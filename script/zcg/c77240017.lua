--DB-孙悟空-苦思对策
function c77240017.initial_effect(c)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90810762,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCondition(c77240017.atkcon)
    e2:SetTarget(c77240017.damtg)
    e2:SetOperation(c77240017.damop)
    c:RegisterEffect(e2)
end
function c77240017.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.GetAttackTarget()==nil
end
function c77240017.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetHandler():GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack())
end
function c77240017.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
