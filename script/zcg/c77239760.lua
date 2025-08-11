--奥西里斯之生命代价
function c77239760.initial_effect(c)

    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
	
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_SUMMON)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c77239760.condition1)	
    e1:SetCost(c77239760.cost1)
    e1:SetTarget(c77239760.target1)
    e1:SetOperation(c77239760.activate1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e3)
	
    --抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77239760.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_SZONE)
    e12:SetOperation(c77239760.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_SZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77239760.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_SZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77239760.distg12)
    c:RegisterEffect(e14)
end
------------------------------------------------------------------------------
function c77239760.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==0
end
function c77239760.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c77239760.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return ep~=tp end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c77239760.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239760.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77239760.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239760.distg12(e,c)
    return c:GetCardTargetCount()>0 and (c:IsSetCard(0xa50) or c:IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end
