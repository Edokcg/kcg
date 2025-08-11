--殉道者的天使女郎
function c77240174.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    --e1:SetTarget(c77240174.target)
    e1:SetOperation(c77240174.activate)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240174.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240174.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240174.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77240174.disop)
    c:RegisterEffect(e13)
end
function c77240174.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct1>=ct2 then return false end
end
function c77240174.filter1(c,e,tp)
    return c:IsControler(tp)
end
function c77240174.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77240174.filter1,1,nil,nil,1-tp)
end
function c77240174.filter(c,e,tp)
    return c:IsSetCard(0xa60) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--[[function c77240174.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    local ft1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    if chk==0 then return ft<ft1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ft1-ft
        and Duel.IsExistingMatchingCard(c77240174.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,ft1-ft,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft1-ft,tp,LOCATION_HAND+LOCATION_GRAVE)
end]]
function c77240174.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    local ft1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240174.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,ft1-ft,ft1-ft,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c77240174.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240174.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240174.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end