--殉道者 魁首龙(ZCG)
function c77239315.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239315.ttcon)
    e1:SetOperation(c77239315.ttop)
    if aux.IsKCGScript then
        e1:SetValue(SUMMON_TYPE_TRIBUTE)
    else 
        e1:SetValue(SUMMON_TYPE_ADVANCE)
    end
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239315.setcon)
    c:RegisterEffect(e2)

    --攻防
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SET_ATTACK_FINAL)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c77239315.adval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
    c:RegisterEffect(e5)
	

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239315.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239315.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239315.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239315.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239315.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239315.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239315.setcon(e,c,minc)
    if not c then return true end
    return false
end
-----------------------------------------------------------------------------
function c77239315.filter(c)
    return c:IsFaceup() and c:GetCode()~=77239315
end
function c77239315.adval(e,c)
	local tp=e:GetHandler():GetControler()
    local g=Duel.GetMatchingGroup(c77239315.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()==0 then
        return 300
    else
        local sg,val=g:GetMaxGroup(Card.GetAttack)
        return val+300
    end
end
-----------------------------------------------------------------------------
function c77239315.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239315.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239315.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

