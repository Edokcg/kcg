 --黑魔导 LV3
function c77239991.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239991.spcon)
    c:RegisterEffect(e1)
	
    --attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239991.atkval)
    c:RegisterEffect(e2)	
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCategory(CATEGORY_NEGATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c77239991.negcon)
    e3:SetCost(c77239991.cost)
    e3:SetTarget(c77239991.reptg)
    e3:SetOperation(c77239991.negop)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------------
function c77239991.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c77239991.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
    Duel.GetMatchingGroupCount(c77239991.filter,c:GetControler(),LOCATION_MZONE,0,nil)==0
end
--------------------------------------------------------------------
function c77239991.atkval(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_SPELLCASTER)*500
end
--------------------------------------------------------------------
function c77239991.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c77239991.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77239991.repfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c77239991.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239991.filter1(c,e,tp)
    return c:IsCode(77239992) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239991.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239991.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)	
end
function c77239991.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239991.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end	
end


