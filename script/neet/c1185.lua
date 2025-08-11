local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.matfilter,2,2)
    --choose effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCondition(s.sumcon)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_DEFENSE))
    e4:SetValue(aux.indoval)
    c:RegisterEffect(e4)
    --cannot be target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetCondition(s.sumcon)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_DEFENSE))
    e5:SetValue(aux.tgoval)
    c:RegisterEffect(e5)
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetTarget(s.reptg)
    e3:SetOperation(s.repop)
    c:RegisterEffect(e3)
end
function s.matfilter(c,lc,st,tp)
    return not c:IsType(TYPE_LINK,lc,st,tp) and c:IsCode(id,12615446,19301729,32465539,58600555,68950538,83048208,85004150,94344242)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==2
end
function s.spfilter(c,e,tp,sync)
    return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
        and c:GetReason()&0x10000008==0x10000008 and c:GetReasonCard()==sync
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local mg=e:GetHandler():GetMaterial()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return #mg>0 and ft>=#mg
        and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
        and mg:FilterCount(s.spfilter,nil,e,tp,e:GetHandler())==#mg end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,#mg,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local mg=e:GetHandler():GetMaterial()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    if #mg>ft and not mg:FilterCount(aux.NecroValleyFilter(s.spfilter),nil,e,tp,e:GetHandler())==#mg then return end
    local tc=mg:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=mg:GetNext()
    end
    Duel.SpecialSummonComplete()
end
function s.valcheck(e,c)
    local g=c:GetMaterial()
    if not g then return end
    local ct=g:FilterCount(Card.IsCode,nil,id,12615446,19301729,32465539,58600555,68950538,83048208,85004150,94344242)
    if ct==#g then
        e:GetLabelObject():SetLabel(2)
    else
        e:GetLabelObject():SetLabel(1)
    end
end
function s.sumfilter(c)
    return c:IsFaceup() and c:IsCode(id,12615446,19301729,32465539,58600555,68950538,83048208,85004150,94344242)
end
function s.sumcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function s.repfilter(c,e)
    return c:IsFaceup() and c:IsCode(id,12615446,19301729,32465539,58600555,68950538,83048208,85004150,94344242)
        and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
        and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
        Duel.SetTargetCard(g)
        g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
        return true
    else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
    Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end