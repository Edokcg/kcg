--奥西里斯之圣阶天使(ZCG)
function c77239700.initial_effect(c)

    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c77239700.efilter)
    c:RegisterEffect(e1)
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c77239700.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e3:SetTarget(c77239700.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e4:SetTarget(c77239700.distg2)
    c:RegisterEffect(e4)
	
    --unaffectable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c77239700.efilter1)
    c:RegisterEffect(e5)

    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BATTLE_START)
    --e6:SetCondition(c77239700.descon)
    e6:SetTarget(c77239700.destg)
    e6:SetOperation(c77239700.desop)
    c:RegisterEffect(e6)
end
---------------------------------------------------------------------------------
function c77239700.efilter(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77239700.disop2(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239700.distg2(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end
---------------------------------------------------------------------------------
function c77239700.efilter1(e,te)
    return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------------------------------
--[[function c77239700.descon(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return e:GetHandler()==Duel.GetAttacker() and d
end
function c77239700.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,0,0)
end
function c77239700.desop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    local atk=d:GetAttack()
    if d:IsRelateToBattle() then
        Duel.Destroy(d,REASON_RULE)
        Duel.Recover(tp,atk,REASON_EFFECT)
    end
end]]

function c77239700.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c77239700.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local atk=tc:GetAttack()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then
        Duel.Destroy(tc,REASON_RULE,LOCATION_REMOVED)
        Duel.Recover(tp,atk,REASON_EFFECT)
    end
end