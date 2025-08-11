--奥西里斯之紫檀翼龙
function c77239711.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c77239711.efilter)
    c:RegisterEffect(e1)
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c77239711.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e3:SetTarget(c77239711.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e4:SetTarget(c77239711.distg2)
    c:RegisterEffect(e4)
	
	--
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_SELF_DESTROY)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e8:SetTarget(c77239711.destarget)
    c:RegisterEffect(e8)
end
-----------------------------------------------------------------
function c77239711.destarget(e,c)
    return not c:IsSetCard(0xa100) and c:IsType(TYPE_MONSTER)
end
---------------------------------------------------------------------------------
function c77239711.efilter(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77239711.disop2(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239711.distg2(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end
