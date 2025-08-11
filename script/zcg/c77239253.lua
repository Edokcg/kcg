--达姿的仪式 （ZCG）
function c77239253.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239253.cost)
    e1:SetTarget(c77239253.target)
    e1:SetOperation(c77239253.activate)
    c:RegisterEffect(e1)
end
function c77239253.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    if aux.IsKCGScript then
        e1:SetCode(EFFECT_CANNOT_LOSE_LP)
    else 
        e1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
    end
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
    Duel.PayLPCost(tp,Duel.GetLP(tp))
end
function c77239253.filter(c,e,tp)
    return c:IsCode(77239230) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c77239253.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239253.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239253.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239253.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if not tc then return end 
    if Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)<=0 then return end
    if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetOperation(c77239253.lose)
    tc:RegisterEffect(e1)
    end
end
function c77239253.lose(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(1-tp,0x504)
end