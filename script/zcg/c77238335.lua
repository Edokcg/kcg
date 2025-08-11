--太阳神之光龙
function c77238335.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetTarget(c77238335.target)
    e1:SetOperation(c77238335.operation)
    c:RegisterEffect(e1)
	
	--battle indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetCountLimit(1)
    e2:SetValue(c77238335.valcon)
    c:RegisterEffect(e2)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77238335.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238335.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238335.distg2)
    c:RegisterEffect(e54)	
end

function c77238335.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-------------------------------------------------------------------------
function c77238335.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238335.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77238335.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetHandler():GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetAttack())
end
function c77238335.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
