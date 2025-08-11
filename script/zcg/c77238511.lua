--欧贝利斯克之火焰兵(ZCG)
function c77238511.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(c77238511.spcon)
    e1:SetOperation(c77238511.spop)
    c:RegisterEffect(e1)
	
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c77238511.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0xa,0xa)
    e3:SetTarget(c77238511.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0xa,0xa)
    e4:SetTarget(c77238511.distg2)
    c:RegisterEffect(e4)

    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77238511,1))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77238511.cost)
    e7:SetOperation(c77238511.activate)
    c:RegisterEffect(e7)


    --cannot trigger
    local e101=Effect.CreateEffect(c)
    e101:SetType(EFFECT_TYPE_FIELD)
    e101:SetCode(EFFECT_CANNOT_TRIGGER)
    e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e101:SetRange(LOCATION_MZONE)
    e101:SetTargetRange(0,0xa)
    e101:SetTarget(c77238511.distg)
    c:RegisterEffect(e101)
    --disable
    local e102=Effect.CreateEffect(c)
    e102:SetType(EFFECT_TYPE_FIELD)
    e102:SetCode(EFFECT_DISABLE)
    e102:SetRange(LOCATION_MZONE)
    e102:SetTargetRange(0,LOCATION_ONFIELD)
    e102:SetTarget(c77238511.distg)
    c:RegisterEffect(e102)
    --disable effect
    local e103=Effect.CreateEffect(c)
    e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e103:SetCode(EVENT_CHAIN_SOLVING)
    e103:SetRange(LOCATION_MZONE)
    e103:SetOperation(c77238511.disop)
    c:RegisterEffect(e103)
	--
    local e104=Effect.CreateEffect(c)
    e104:SetType(EFFECT_TYPE_FIELD)
    e104:SetCode(EFFECT_SELF_DESTROY)
    e104:SetRange(LOCATION_MZONE)
    e104:SetTargetRange(0,LOCATION_ONFIELD)
    e104:SetTarget(c77238511.distg)
    c:RegisterEffect(e104)	
end
------------------------------------------------------------------
function c77238511.spfilter(c)
    return c:IsReleasable()
end
function c77238511.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.CheckReleaseGroup(tp,c77238511.spfilter,3,nil)
end
function c77238511.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c77238511.spfilter,3,3,nil)
    Duel.Release(g1,REASON_COST)
end
------------------------------------------------------------------
function c77238511.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238511.distg2(e,c)
    return c:GetCardTargetCount()>0
        and c:GetCardTarget():IsContains(e:GetHandler())
end
------------------------------------------------------------------
function c77238511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77238511.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77238511.distg(e,c)
    return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function c77238511.disop(e,tp,eg,ep,ev,re,r,rp)
    if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:IsControler(1-tp) then
        Duel.NegateEffect(ev)
    end
end


