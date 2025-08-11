--卡通神炎皇
function c77240075.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77240075,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240075.sctg)
    e1:SetOperation(c77240075.scop)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77240075,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77240075.spcost)
    e2:SetTarget(c77240075.sptg)
    e2:SetOperation(c77240075.spop)
    c:RegisterEffect(e2)	

    --direct attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    e3:SetCondition(c77240075.dircon)
    c:RegisterEffect(e3)
	
    --indes
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
-------------------------------------------------------------------
function c77240075.filter(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c77240075.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240075.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77240075.scop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77240075.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
-------------------------------------------------------------------
function c77240075.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77240075.spfilter(c,e,tp)
    return c:IsCode(6007213) or c:IsCode(511000234) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77240075.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77240075.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240075.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240075.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
-------------------------------------------------------------------
function c77240075.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x62)
end
function c77240075.cfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240075.dircon(e)
    local tp=e:GetHandlerPlayer()
    return not Duel.IsExistingMatchingCard(c77240075.atkfilter,tp,0,LOCATION_MZONE,1,nil) and 
	Duel.IsExistingMatchingCard(c77240075.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
