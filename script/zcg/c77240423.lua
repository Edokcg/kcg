--上古神殿(ZCG)
local s,id=GetID()
function s.initial_effect(c)
c:EnableCounterPermit(0xa11)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
--summon success
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(1040)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(s.addcon)
    e3:SetTarget(s.addct)
    e3:SetOperation(s.addc)
    c:RegisterEffect(e3)
--
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCost(s.cost)
    e4:SetTarget(s.rectg)
    e4:SetOperation(s.recop)
    c:RegisterEffect(e4)
     --cannot be destroyed
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_FZONE)
    e11:SetValue(s.efilter2)
    c:RegisterEffect(e11)
 --disable spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,1)
    e2:SetTarget(s.sumlimit)
    c:RegisterEffect(e2)
     if not s.global_check then
    s.global_check=true
    s[0]=0
    s[1]=0
    end
end
function s.filter(c,e,tp)
    return c:IsSetCard(0xa120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xa11,3,REASON_COST)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND+LOCATION_GRAVE)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) 
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetLP(tp)~=s[tp] 
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    s[tp]=Duel.GetLP(tp)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa11)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
        e:GetHandler():AddCounter(0xa11,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
       s[tp]=Duel.GetLP(tp)
end
function s.efilter2(e,re)
    return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsSetCard(0xa120)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return not c:IsSetCard(0xa120)
end

