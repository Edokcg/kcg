--卡通幻魔皇
function c77240073.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(77240073,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240073.target1)
    e1:SetOperation(c77240073.operation1)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77240073,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77240073.cost)
    e2:SetTarget(c77240073.target)
    e2:SetOperation(c77240073.operation)
    c:RegisterEffect(e2)

    --Direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c77240073.dircon)
	c:RegisterEffect(e3)

	--不会被破环
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)
end
-----------------------------------------------------------------
function c77240073.filter1(c)
    return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c77240073.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240073.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77240073.operation1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77240073.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-----------------------------------------------------------------
function c77240073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c77240073.filter(c,e,tp)
    return (c:IsCode(69890967) or c:IsCode(511000261)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77240073.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240073.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240073.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240073.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)	
    end
end
-----------------------------------------------------------------
function c77240073.cfilter1(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240073.cfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x62)
end
function c77240073.dircon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(c77240073.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c77240073.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end