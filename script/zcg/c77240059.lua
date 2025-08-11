--火焰之纹章
function c77240059.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77240059.target)
    e1:SetOperation(c77240059.operation)
    c:RegisterEffect(e1)
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    --def up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetValue(500)
    c:RegisterEffect(e3)
    --equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c77240059.eqlimit)
    c:RegisterEffect(e4)
	
    --salvage
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetDescription(aux.Stringid(1100708,1))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCost(c77240059.thcost)
    e5:SetTarget(c77240059.thtg)
    e5:SetOperation(c77240059.thop)
    c:RegisterEffect(e5) 	
end
-----------------------------------------------------------------------
function c77240059.eqlimit(e,c)
    return c:IsFaceup()
end
function c77240059.filter(c)
    return c:IsFaceup()
end
function c77240059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77240059.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77240059.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77240059.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77240059.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
-----------------------------------------------------------------------
function c77240059.thfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c77240059.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240059.thfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77240059.thfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77240059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77240059.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end

