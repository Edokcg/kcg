--殉道者 双子白骨
function c77239347.initial_effect(c)
    --coin effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239347,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77239347.sptg)
    e1:SetOperation(c77239347.spop)
    c:RegisterEffect(e1)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239347.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239347.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239347.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239347.disop)
    c:RegisterEffect(e13)
end
function c77239347.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,77239348,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77239347.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,77239348,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
    local token=Duel.CreateToken(tp,77239348)
    local token1=Duel.CreateToken(tp,77239348)	
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    Duel.SpecialSummon(token1,0,tp,tp,false,false,POS_FACEUP)
end
---------------------------------------------------------------------------------
function c77239347.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239347.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239347.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
