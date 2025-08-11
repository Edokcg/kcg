--七彩幻界植物女王(ZCG)
function c77239600.initial_effect(c)
    --cannot select battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetValue(c77239600.atlimit)
    c:RegisterEffect(e1)

    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239600.desreptg)
    e2:SetOperation(c77239600.desrepop)
    c:RegisterEffect(e2)

    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239600,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239600.cost)
    e3:SetTarget(c77239600.sptg)
    e3:SetOperation(c77239600.spop)
    c:RegisterEffect(e3)	
end
-------------------------------------------------------------------
function c77239600.atlimit(e,c)
    return c~=e:GetHandler() and c:IsFaceup()
	and (c:IsSetCard(0xa90) or c:IsSetCard(0x10f3) or c:IsCode(20546916) or c:IsCode(51119924)
	or c:IsCode(53257892) or c:IsCode(66457407) or c:IsCode(84824601) or c:IsCode(7670542)
	or c:IsCode(13193642) or c:IsCode(49127943) or c:IsCode(53830602) or c:IsCode(60715406))
end
-------------------------------------------------------------------
function c77239600.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField()
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,0,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(77239600,1)) then
        local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)

        return true
    else return false end
end
function c77239600.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
    Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)	
end
-------------------------------------------------------------------
function c77239600.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77239600.filter(c,e,tp)
    return c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	(c:IsSetCard(0xa90) or c:IsSetCard(0x10f3) or c:IsCode(20546916) or c:IsCode(51119924)
	or c:IsCode(53257892) or c:IsCode(66457407) or c:IsCode(84824601) or c:IsCode(7670542)
	or c:IsCode(13193642) or c:IsCode(49127943) or c:IsCode(53830602) or c:IsCode(60715406))
end
function c77239600.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239600.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239600.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239600.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end


