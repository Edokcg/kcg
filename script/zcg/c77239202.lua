--奥利哈刚 克莉丝(ZCG)
function c77239202.initial_effect(c)
    --不能发动卡
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetCondition(c77239202.con)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c77239202.aclimit)
    c:RegisterEffect(e1) 
    
	--伤害
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCondition(c77239202.damcon)
    e2:SetTarget(c77239202.damtg)
    e2:SetOperation(c77239202.damop)
    c:RegisterEffect(e2)   
end
--------------------------------------------------------------------
function c77239202.con(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c77239202.aclimit(e,re,tp)
    local rc=re:GetHandler()
    return (rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--------------------------------------------------------------------
function c77239202.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77239202.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*600
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239202.damop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*600
    Duel.Damage(p,dam,REASON_EFFECT)
end