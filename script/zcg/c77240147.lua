--殉道者 盗墓人
function c77240147.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_LEAVE_FIELD)
    --e1:SetCondition(c77240147.spcon1)
    e1:SetTarget(c77240147.sptg)
    e1:SetOperation(c77240147.spop)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240147.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240147.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240147.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240147.disop)
    c:RegisterEffect(e13)
end
---------------------------------------------------------------------
--[[function c77240147.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end]]
function c77240147.spfilter2(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240147.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingTarget(c77240147.spfilter2,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77240147.spfilter2,tp,0,LOCATION_GRAVE,1,2,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77240147.spop(e,tp,eg,ep,ev,re,r,rp)
    --local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    --if ft<2 or g:GetCount()~=2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

function c77240147.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240147.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240147.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end