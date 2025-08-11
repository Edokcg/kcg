--殉道者之逆转
function c77239385.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    --e1:SetCondition(c77239385.condition)	
    e1:SetCost(c77239385.cost)
    e1:SetTarget(c77239385.target)
    e1:SetOperation(c77239385.activate)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239385.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239385.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239385.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239385.disop)
    c:RegisterEffect(e13)
end
--[[function c77239385.condition(e)
    return Duel.GetLP(tp)<1000
end]]
function c77239385.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,77239385)==0 end
    Duel.RegisterFlagEffect(tp,77239385,0,0,0)
end
function c77239385.tdfilter(c)
    return c:IsAbleToDeck()
end
function c77239385.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239385.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c77239385.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c77239385.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<=1000 then
    local g=Duel.GetMatchingGroup(c77239385.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.Draw(tp,5,REASON_EFFECT)
    Duel.SetLP(tp,8000)
    Duel.BreakEffect()
    e:GetHandler():CancelToGrave()
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end

function c77239385.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239385.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239385.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end