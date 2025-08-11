--殉道者的毁灭一击
function c77240173.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)	
    e2:SetDescription(aux.Stringid(77240173,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCost(c77240173.cost)
    e2:SetTarget(c77240173.target)
    e2:SetOperation(c77240173.activate)
    c:RegisterEffect(e2)
	
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)	
    e3:SetDescription(aux.Stringid(77240173,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCost(c77240173.cost)
    e3:SetTarget(c77240173.target1)
    e3:SetOperation(c77240173.activate1)
    c:RegisterEffect(e3)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240173.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240173.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240173.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77240173.disop)
    c:RegisterEffect(e13)
end
-------------------------------------------------------------------
function c77240173.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xa60) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xa60)
    Duel.Release(g,REASON_COST)
end
function c77240173.filter(c)
    return  c:IsAbleToHand()
end
function c77240173.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c77240173.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77240173.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c77240173.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77240173.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end
-------------------------------------------------------------------
function c77240173.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c77240173.activate1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        Duel.ConfirmCards(tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
        Duel.ShuffleHand(1-tp)
    end
end

function c77240173.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240173.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240173.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end