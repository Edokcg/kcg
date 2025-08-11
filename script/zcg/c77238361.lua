--太阳神之能量封印
function c77238361.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --activate cost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ACTIVATE_COST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0,1)
    e2:SetTarget(c77238361.actarget)
    e2:SetCost(c77238361.costchk)
    e2:SetOperation(c77238361.costop)
    c:RegisterEffect(e2)
	
   --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238361.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238361.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238361.distg2)
    c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function c77238361.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238361.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
---------------------------------------------------------------------------
function c77238361.actarget(e,te,tp)
    return te:GetHandler():IsType(TYPE_SPELL) or te:GetHandler():IsType(TYPE_TRAP)
end
function c77238361.costchk(e,te_or_c,tp)
    return Duel.CheckLPCost(tp,500)
end
function c77238361.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,77238361)
    Duel.PayLPCost(tp,500)
end
