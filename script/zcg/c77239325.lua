--殉道者 百鬼夜行将(ZCG)
function c77239325.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_DAMAGE_STEP_END)
    e1:SetCondition(c77239325.descon)
    e1:SetTarget(c77239325.target)
    e1:SetOperation(c77239325.operation)
    c:RegisterEffect(e1)
	
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239325.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239325.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239325.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239325.disop)
    c:RegisterEffect(e13)
end
--------------------------------------------------------------------
function c77239325.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function c77239325.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c77239325.operation(e,tp,eg,ep,ev,re,r,rp)
    local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*1000
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Damage(p,rt,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239325.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239325.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239325.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

