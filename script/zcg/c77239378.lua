--殉道者之意志
function c77239378.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetHintTiming(0,TIMING_END_PHASE)	
    c:RegisterEffect(e0)
	
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239378,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c77239378.condition)
    e1:SetTarget(c77239378.target)
    e1:SetOperation(c77239378.operation)
    c:RegisterEffect(e1)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239378.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239378.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239378.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239378.disop)
    c:RegisterEffect(e13)	
end
--------------------------------------------------------------------
function c77239378.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa60)
end
function c77239378.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239378.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local rec=Duel.GetMatchingGroupCount(c77239378.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000	
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c77239378.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
--------------------------------------------------------------------
function c77239378.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239378.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239378.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

