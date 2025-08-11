--殉道者之深渊审判官(ZCG)
function c77239357.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --atkdown
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239357,1))
    e8:SetCategory(CATEGORY_ATKCHANGE)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_SZONE)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetCondition(c77239357.atkcon)
    e8:SetTarget(c77239357.atktg)
    e8:SetOperation(c77239357.atkop)
    c:RegisterEffect(e8)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239357.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239357.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239357.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239357.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239357.atkfilter(c,e,tp)
    return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c77239357.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239357.atkfilter,1,nil,nil,1-tp)
end
function c77239357.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
    Duel.SetTargetCard(eg)
end
function c77239357.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c77239357.atkfilter,nil,e,1-tp)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Destroy(dg,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239357.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239357.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239357.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
