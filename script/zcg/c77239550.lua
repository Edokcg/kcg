--女子佣兵 斩月(ZCG)
function c77239550.initial_effect(c)
    --Disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLED)
    --e3:SetCondition(c77239550.condition)
    e3:SetOperation(c77239550.operation)
    c:RegisterEffect(e3)
	
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239550,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCondition(c77239550.damcon)
    e1:SetTarget(c77239550.damtg)
    e1:SetOperation(c77239550.damop)
    c:RegisterEffect(e1)	
end
-----------------------------------------------------------------------------------
--[[function c77239550.condition(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return e:GetHandler()==Duel.GetAttacker() and d and d:IsRelateToBattle()
end]]
function c77239550.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if tc:IsRelateToBattle() then 
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(1)
        --e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
    end
end
-----------------------------------------------------------------------------------
function c77239550.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c77239550.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local bc=e:GetHandler():GetBattleTarget()
    local dam=bc:GetLevel()*500
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239550.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

