--女子佣兵 魔音(ZCG)
function c77239502.initial_effect(c)
    --summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239502,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239502.otcon)
    e1:SetOperation(c77239502.otop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    c:RegisterEffect(e2)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238982,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetTarget(c77239502.sptg)
    e3:SetOperation(c77239502.spop)
    c:RegisterEffect(e3)
end
function c77239502.otfilter(c,tp)
    return c:IsCode(77239522) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239502.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239502.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg)       
end
function c77239502.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239502.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239502.filter(c,e,tp)
    return c:IsSetCard(0x5034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239502.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239502.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239502.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil,e,tp)
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        tc=g:GetNext()
    end
    Duel.Damage(1-tp,g:GetCount()*2000,REASON_EFFECT)
end