--太阳神之无懈可击
function c77238363.initial_effect(c)
    --reflect
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c77238363.condition)
    e1:SetOperation(c77238363.operation)
    c:RegisterEffect(e1)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238363.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238363.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238363.distg2)
    c:RegisterEffect(e54)
end
function c77238363.condition(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
    if ex and (cp==tp or cp==PLAYER_ALL) then return true end
    ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
    return ex and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end
function c77238363.operation(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_REFLECT_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(cid)
    e1:SetValue(c77238363.refcon)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
end
function c77238363.refcon(e,re,val,r,rp,rc)
    local cc=Duel.GetCurrentChain()
    if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    return cid==e:GetLabel()
end

function c77238363.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
  end
  function c77238363.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
  end