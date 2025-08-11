--殉道者 地狱看守人
function c77240149.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77240149,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e1:SetTarget(c77240149.target)
    e1:SetOperation(c77240149.activate)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77240149,1))
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e2:SetTarget(c77240149.target1)
    e2:SetOperation(c77240149.activate1)
    c:RegisterEffect(e2)

    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77240149,2))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetTarget(c77240149.target2)
    e3:SetOperation(c77240149.activate2)
    c:RegisterEffect(e3)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240149.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240149.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240149.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240149.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------
function c77240149.filter(c)
    return c:IsAbleToHand()
end
function c77240149.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240149.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c77240149.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77240149.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c77240149.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
-----------------------------------------------------------------
function c77240149.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c77240149.activate1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
    local sg=g:RandomSelect(1-tp,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
-----------------------------------------------------------------
function c77240149.filter2(c)
    return c:IsAbleToRemove()
end
function c77240149.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240149.filter2,tp,0,LOCATION_GRAVE,1,nil) end
    local g=Duel.GetMatchingGroup(c77240149.filter2,tp,0,LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77240149.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77240149.filter2,tp,0,LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end

function c77240149.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240149.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240149.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end