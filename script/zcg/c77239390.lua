--殉道者之反射罩
function c77239390.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239390.rectg1)
    e2:SetOperation(c77239390.recop1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_SZONE)	
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c77239390.rectg1)	
    e3:SetOperation(c77239390.recop2)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239390,0))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c77239390.damcon)
    e4:SetTarget(c77239390.damtg)
    e4:SetOperation(c77239390.damop)
    c:RegisterEffect(e4)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239390.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239390.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239390.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239390.disop)
    c:RegisterEffect(e13)
end
-------------------------------------------------------------------
function c77239390.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return rp==tp end
end
function c77239390.recop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local rec=tc:GetLevel()*100
    Duel.Recover(tp,rec,REASON_EFFECT)
end
function c77239390.filter(c,e,tp)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()==tp
end
function c77239390.recop2(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c77239390.filter,nil,e,tp)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=g:GetFirst()
    local lv=0	
    while tc do	
        local lvx=tc:GetLevel()   
	    lv=lv+lvx
        tc=g:GetNext()
    end	
    Duel.Recover(tp,lv*100,REASON_EFFECT)
end
-------------------------------------------------------------------
function c77239390.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77239390.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(3000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c77239390.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239390.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239390.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239390.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

