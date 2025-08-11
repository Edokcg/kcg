--欧贝里斯克之铠甲-护腿
function c77238506.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(c77238506.sumsuc)
    c:RegisterEffect(e3)
	
	--[[spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DRAW)
    e4:SetCondition(c77238506.con)	
    e4:SetOperation(c77238506.desop)
    c:RegisterEffect(e4)]]
	
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetCode(EVENT_DRAW--[[EVENT_PHASE+PHASE_STANDBY]])
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c77238506.spcon)
    e4:SetTarget(c77238506.sptg)
    e4:SetOperation(c77238506.spop)
    c:RegisterEffect(e4)
end

function c77238506.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

--[[function c77238506.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c77238506.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77238506.desop(e,tp,eg,ep,ev,re,r,rp)
    if ep~=e:GetOwnerPlayer() then return end
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    local dg=hg:Filter(c77238506.filter,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22567609,1)) then
        Duel.ConfirmCards(1-tp,dg)
		Duel.SpecialSummon(dg,0,tp,tp,true,true,POS_FACEUP)
    end
end]]

function c77238506.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77238506.spfilter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77238506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77238506.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--[[function c77238506.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77238506.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end]]
function c77238506.spop(e,tp,eg,ep,ev,re,r,rp)
    if ep~=e:GetOwnerPlayer() then return end
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    local dg=hg:Filter(c77238506.spfilter,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22567609,1)) then
        Duel.ConfirmCards(1-tp,dg)
		Duel.SpecialSummon(dg,0,tp,tp,true,true,POS_FACEUP)
    end
end