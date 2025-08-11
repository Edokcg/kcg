--废品装甲战士(neet)
local s,id=GetID()
function s.initial_effect(c)
        c:EnableReviveLimit()
        Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,nil,s.matcheck)
        --multi attack
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
        e2:SetCode(EVENT_SPSUMMON_SUCCESS)
        e2:SetCondition(s.mtcon)
        e2:SetOperation(s.mtop)
        c:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_MATERIAL_CHECK)
        e3:SetValue(s.valcheck)
        e3:SetLabelObject(e2)
        c:RegisterEffect(e3)
        --
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,0))
        e1:SetCategory(CATEGORY_DISABLE)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e1:SetType(EFFECT_TYPE_IGNITION)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCost(s.distg)
        e1:SetOperation(s.disop)
        c:RegisterEffect(e1)
        --sp sum
        local e4=Effect.CreateEffect(c)
        e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
        e4:SetProperty(EFFECT_FLAG_DELAY)
        e4:SetCode(EVENT_TO_GRAVE)
        e4:SetCondition(s.tdcondition)
        e4:SetTarget(s.tdtarget)
        e4:SetOperation(s.tdoperation)
        c:RegisterEffect(e4)
end
s.listed_series={0x43,0x66}
function s.matcheck(g,lc,sumtype,tp)
    return g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO,lc,sumtype,tp)
end
function s.valcheck(e,c)
    local g=c:GetMaterial()
    local ct=g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
    e:GetLabelObject():SetLabel(ct)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    e1:SetValue(ct)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    e2:SetValue(ct*500)
    c:RegisterEffect(e2)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local ct=g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
    if ct==0 then return end
    if chkc then return ct<c:GetFlagEffect(id) and chkc:IsOnField() and chkc:IsNegatable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local tc=Duel.SelectTarget(tp,Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,LOCATION_ONFIELD)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsNegatable() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function s.tdcondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and rp==1-tp
end
function s.spfilter1(c,e,tp)
    return c:IsSetCard(0x66) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
        and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,c,e,tp)
end
function s.spfilter2(c,e,tp)
    return c:IsSetCard(0x43) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end
function s.tdtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
        and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.tdoperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMasterRule()==4 then 
        if Duel.GetLocationCountFromEx(tp)<2
            or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    else
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
            or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst(),e,tp)
    g1:Merge(g2)
    if g1:GetCount()==2 and Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
        local tc=g1:GetFirst()
        for tc in aux.Next(g1) do
            tc:CompleteProcedure()
        end
    end
end