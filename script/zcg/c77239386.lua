--殉道者之异次元穿越
function c77239386.initial_effect(c)
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c77239386.condition)
    e1:SetTarget(c77239386.target)
    e1:SetOperation(c77239386.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239386.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239386.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239386.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239386.disop)
    c:RegisterEffect(e13)
end
function c77239386.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    e:SetLabel(tc:GetLevel())
    return eg:GetCount()==1 and tc:IsFaceup() and tc:GetSummonPlayer()~=tp
end
function c77239386.spfilter(c,e,tp,lv)
    return c:GetLevel()==lv+2 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239386.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local lv=e:GetLabel()
    if lv>10 then lv=10 end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239386.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239386.activate(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    if lv>10 then lv=10 end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239386.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end

function c77239386.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239386.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239386.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end