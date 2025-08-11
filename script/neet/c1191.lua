--正义盟军 探路者（neet）
local s,id=GetID()
function s.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),2)
 --Attribute change
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(ATTRIBUTE_LIGHT)
    c:RegisterEffect(e1)
  -- Battle protection
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCountLimit(100000)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.indtg)
    e2:SetValue(function(_,_,r) return r&REASON_BATTLE==REASON_BATTLE end)
    c:RegisterEffect(e2)
--immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1))
    e3:SetCondition(s.spcon)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(s.efilter)
    c:RegisterEffect(e3)
--Special Summon from your GY
    local e20=Effect.CreateEffect(c)
    e20:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e20:SetType(EFFECT_TYPE_IGNITION)
    e20:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e20:SetRange(LOCATION_MZONE)
    e20:SetCost(s.spcost2)
    e20:SetTarget(s.sptg2)
    e20:SetOperation(s.spop2)
    c:RegisterEffect(e20)
end
s.listed_series={0x1}
function s.indtg(e,c)
    local bt=c:GetBattleTarget()
    return c:IsSetCard(0x1) and bt and bt:IsAttribute(ATTRIBUTE_LIGHT) 
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_MACHINE) 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return #g>0 and g:FilterCount(s.cfilter,nil)==#g
end
function s.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
        and re:GetOwner():IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
end
function s.spfilter2(c,e,tp)
    return c:IsSetCard(0x1) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter2(chkc,e,tp) end
    if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end