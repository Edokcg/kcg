--正义使者瓦奇
function c77239592.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239592,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCondition(c77239592.reccon)
    e1:SetTarget(c77239592.rectg)
    e1:SetOperation(c77239592.recop)
    c:RegisterEffect(e1)
end
------------------------------------------------------------------
function c77239592.reccon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local t=Duel.GetAttackTarget()
    if ev==1 then t=Duel.GetAttacker() end
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    e:SetLabel(t:GetAttack())
    return t:GetLocation()==LOCATION_GRAVE and t:IsType(TYPE_MONSTER)
end
function c77239592.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c77239592.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

