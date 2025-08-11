--植物的愤怒 魔古树
function c77239611.initial_effect(c)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239611,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(c77239611.damcon)
    e1:SetTarget(c77239611.damtg)
    e1:SetOperation(c77239611.damop)
    c:RegisterEffect(e1)
end
-----------------------------------------------------------------
function c77239611.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and c:IsFaceup() and bc:IsLocation(LOCATION_GRAVE)
        and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c77239611.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(2000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c77239611.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end