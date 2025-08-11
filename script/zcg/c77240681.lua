--不死之究极昆虫 LV5(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_ADJUST)
    e1:SetCondition(s.con)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate) 
    c:RegisterEffect(e1) 
 --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetCondition(s.spcon)
    e2:SetCost(s.spcost)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
s.lvup={77240681,77238031}
s.lvdn={77240679,77240680}
function s.con(e)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_LV
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() 
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp)
    return c:IsCode(77238031) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,SUMMON_VALUE_LV,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function s.filter(c)
return c:GetAttack()>0 and c:GetFlagEffect(id)<=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
    local tc=sg:GetFirst()
    local dg=Group.CreateGroup()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc:RegisterFlagEffect(id,RESET_EVENT+0x1ec0000,0,1)
        if tc:GetAttack()<=1000 then
            dg:AddCard(tc)
        end
        tc=sg:GetNext()
    end
    if #dg>0 then
        Duel.Destroy(dg,REASON_EFFECT)
    end
end








