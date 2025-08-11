--殉道者 地狱魔人使
function c77239345.initial_effect(c)
    --attack up
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239345,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239345.condition)
    e1:SetOperation(c77239345.operation)
    c:RegisterEffect(e1)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239345.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239345.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239345.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239345.disop)
    c:RegisterEffect(e13)
end
--------------------------------------------------------------------
function c77239345.condition(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    e:SetLabelObject(tc)
    return tc and tc:IsFaceup() and tc:IsSetCard(0xa60) and tc:IsRelateToBattle()
end
function c77239345.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    local t=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)	
    if not tc:IsRelateToBattle() or tc:IsFacedown() and t<1  then return end
    local t1={}
    for i=1,t do t1[i]=i end	
    local announce=Duel.AnnounceNumber(tp,table.unpack(t1))
    local ct=Duel.DiscardDeck(tp,announce,REASON_COST)	
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetValue(ct*500)
    tc:RegisterEffect(e1)
end
--------------------------------------------------------------------
function c77239345.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239345.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239345.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end