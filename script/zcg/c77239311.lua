--殉道者 遮面幻王(ZCG)
function c77239311.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239311.ttcon)
    e1:SetOperation(c77239311.ttop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_LIMIT_SET_PROC)
    e5:SetCondition(c77239311.setcon)
    c:RegisterEffect(e5)
	
	--提升攻击力
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetTarget(c77239311.distg)
    e4:SetOperation(c77239311.drop)
	c:RegisterEffect(e4)
	

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239311.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239311.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239311.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239311.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239311.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239311.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239311.setcon(e,c,minc)
    if not c then return true end
    return false
end
-----------------------------------------------------------------------------
function c77239311.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,10) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(10)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,10)
end
function c77239311.cfilter(c)
    return c:IsSetCard(0xa60) and c:IsLocation(LOCATION_GRAVE)
end
function c77239311.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.DiscardDeck(p,d,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(c77239311.cfilter,nil)
    if ct>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ct*1000)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1) 
    end
end
-----------------------------------------------------------------------------
function c77239311.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239311.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239311.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
