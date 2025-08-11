--殉道者之预兆(ZCG)
function c77239351.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)	
    e2:SetCountLimit(1)
    e2:SetTarget(c77239351.target)
    e2:SetOperation(c77239351.operation)
    c:RegisterEffect(e2)


	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239351.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239351.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239351.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239351.disop)
    c:RegisterEffect(e13)
end
----------------------------------------------------------------
function c77239351.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1,6) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c77239351.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local dice=Duel.TossDice(tp,1)
    if dice==1 then
        Duel.Draw(tp,1,REASON_EFFECT) 
        Duel.BreakEffect()
    elseif dice==2 then
        Duel.Draw(tp,2,REASON_EFFECT) 
        Duel.BreakEffect()
    elseif dice==3 then
        Duel.Draw(tp,3,REASON_EFFECT) 
        Duel.BreakEffect()
    elseif dice==4 then
        Duel.Draw(tp,4,REASON_EFFECT)
        Duel.BreakEffect() 
    elseif dice==5 then
        Duel.Draw(tp,5,REASON_EFFECT)
        Duel.BreakEffect()
    else
        Duel.Draw(tp,6,REASON_EFFECT)
        Duel.BreakEffect()
    end
end
----------------------------------------------------------------
function c77239351.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239351.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239351.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

