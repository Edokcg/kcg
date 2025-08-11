--机甲天龙 重炮蓝龙
function c77240062.initial_effect(c)
    --Pendulum
    Pendulum.AddProcedure(c)
    --Power Up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77240062.efilter)
    e1:SetValue(1000)
    c:RegisterEffect(e1)

    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95727991,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(2)
    e2:SetCost(c77240062.cost)
    e2:SetTarget(c77240062.target)
    e2:SetOperation(c77240062.operation)
    c:RegisterEffect(e2)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77240062.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77240062.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77240062.distg2)
    c:RegisterEffect(e54)
end
function c77240062.efilter(e,c)
    return (c:IsSetCard(0xdb97) or c:IsSetCard(0xdb97))
end
function c77240062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
    e:SetLabel(sg:GetFirst():GetAttack())
    Duel.Release(sg,REASON_COST)
end
function c77240062.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c77240062.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

function c77240062.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240062.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end