--聚集的祈愿(ZCG)
function c77239574.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239574.cost)	
    e1:SetOperation(c77239574.activate)	
    c:RegisterEffect(e1)
	
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c77239574.target)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c77239574.target)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c77239574.damcon)
    e4:SetTarget(c77239574.damtg)
    e4:SetOperation(c77239574.damop)
    c:RegisterEffect(e4)	
end
----------------------------------------------------------------------
function c77239574.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c77239574.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77239574.target)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
    e1:SetValue(700)
    Duel.RegisterEffect(e1,tp)
end
----------------------------------------------------------------------
function c77239574.target(e,c)
    return c:IsRace(RACE_DRAGON)
end
----------------------------------------------------------------------
function c77239574.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239574.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(5000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,5000)
end
function c77239574.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

