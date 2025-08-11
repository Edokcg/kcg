--黑魔導女孩 蓝将(ZCG)
function c77239951.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239951.val)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239951,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239951.cost)
    e2:SetTarget(c77239951.sptg)
    e2:SetOperation(c77239951.spop)
    c:RegisterEffect(e2)

    --sendtohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239951,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239951.cost)
    e3:SetTarget(c77239951.tg)
    e3:SetOperation(c77239951.op)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------
function c77239951.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,30208479,46986414)*300
end
-----------------------------------------------------------------
function c77239951.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttack()>0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetValue(0)
    e:GetHandler():RegisterEffect(e1)
end
function c77239951.filter(c,e,tp)
    return c:IsSetCard(0x30a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239951.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239951.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c77239951.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239951.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
-----------------------------------------------------------------
function c77239951.filter1(c)
    return c:IsSetCard(0x30a2) and c:IsAbleToHand()
end
function c77239951.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239951.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239951.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239951.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    local opt=0	
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end

