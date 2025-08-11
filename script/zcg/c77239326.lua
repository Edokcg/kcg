--殉道者 人马战士(ZCG)
function c77239326.initial_effect(c)
    --todeck
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77239326.target)
    e1:SetOperation(c77239326.operation)
    c:RegisterEffect(e1)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239326.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239326.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239326.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239326.disop)
    c:RegisterEffect(e13)
end
----------------------------------------------------------------------
function c77239326.filter(c,e,tp)
    return c:IsDestructable() 
end
function c77239326.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77239326.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
    local dc=Duel.GetOperatedGroup():GetFirst()
    if dc:IsSetCard(0xa60) and Duel.IsExistingMatchingCard(c77239326.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
        Duel.BreakEffect()
        Duel.ConfirmCards(1-tp,dc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,c77239326.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
        if dg:GetCount()>0 then
            Duel.HintSelection(dg)
            Duel.Destroy(dg,REASON_EFFECT)
            Duel.ShuffleHand(tp)
        end
    end
end
----------------------------------------------------------------------
function c77239326.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239326.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239326.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
