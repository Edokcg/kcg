--欧贝利斯克之王(ZCG)
function c77238500.initial_effect(c)
    --wudi
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c77238500.efilter)
    c:RegisterEffect(e1)
	
    --Attack All
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetTarget(c77238500.disable)
    e3:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e3)	
	
    --remove
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetTarget(c77238500.rmtg)
    e4:SetOperation(c77238500.rmop)
    c:RegisterEffect(e4)

    --cannot diratk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e5)	
	
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77238500.spcon)
    e2:SetTarget(c77238500.sptg)
    e2:SetOperation(c77238500.spop)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------
function c77238500.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77238500.disable(e,c)
    return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and 
	Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==c
end
---------------------------------------------------------------------
function c77238500.filter(c)
    return c:IsAbleToRemove()
end
function c77238500.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238500.filter,tp,0,LOCATION_SZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77238500.filter,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77238500.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77238500.filter,tp,0,LOCATION_SZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
---------------------------------------------------------------------
function c77238500.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77238500.spfilter(c,e,tp)
    return c:IsSetCard(0xa220) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77238500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77238500.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77238500.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77238500.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end