--圣龙 五头龙
function c77240104.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c77240104.spcon)
    e1:SetOperation(c77240104.spop)
    c:RegisterEffect(e1)

    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77240104.target)
    e2:SetOperation(c77240104.activate)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77240104.spfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAbleToDeckAsCost() 
end
function c77240104.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240104.spfilter,c:GetControler(),LOCATION_GRAVE,0,5,nil)
end
function c77240104.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c77240104.spfilter,tp,LOCATION_GRAVE,0,5,5,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
------------------------------------------------------------------
function c77240104.filter(c)
    return c:IsFaceup() and c:IsAbleToHand()
end
function c77240104.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240104.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    --local g=Duel.GetMatchingGroup(c77240104.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77240104.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    --local g1=Duel.GetMatchingGroup(c77240104.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
    local g=Duel.SelectMatchingCard(tp,c77240104.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(ct*500)
        e:GetHandler():RegisterEffect(e1)
    end
end