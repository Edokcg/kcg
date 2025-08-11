--钻研(ZCG)
function c77239546.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239546.spcon)	
    e1:SetTarget(c77239546.target)
    e1:SetOperation(c77239546.activate)
    c:RegisterEffect(e1)	
end
function c77239546.spcon(e,c)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa80)==0
end
function c77239546.filter(c,e,tp)
    return c:IsCode(77239511) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239546.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239546.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239546.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239546.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
	    local tc=g:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239546.efilter)
        e1:SetCondition(c77239546.condition)		
        tc:RegisterEffect(e1,true)
		tc:SetCardTarget(c)
    end
end
function c77239546.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c77239546.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetFirstCardTarget()
    return tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup()
end