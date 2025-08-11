--冻结的梦
function c77240049.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77240049.cost)
    e1:SetTarget(c77240049.target)
    e1:SetOperation(c77240049.activate)
    c:RegisterEffect(e1)
end
function c77240049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetLabelObject(e)
    e1:SetTarget(c77240049.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c77240049.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return e:GetLabelObject()~=se
end
function c77240049.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,77240050,0,0x4011,1900,1600,4,RACE_MACHINE,ATTRIBUTE_WATER) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77240049.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,77240050,0,0x4011,1900,1600,4,RACE_MACHINE,ATTRIBUTE_WATER) then
        local token=Duel.CreateToken(tp,77240050)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
