--地缚神龙 Visa·Versa(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,1,s.unfilter,LOCATION_MZONE)
  --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1) 
--tograve
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
 --direct atks
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e6)
   --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.sdcon)
    c:RegisterEffect(e4)
 --battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(aux.imval1)
    c:RegisterEffect(e5)
end
function s.unfilter(c)
    return c:IsSetCard(0x21) and not Duel.IsPlayerAffectedByEffect(c:GetControler(),77238003)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function s.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and c:IsRace(RACE_DRAGON)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
    if g:GetCount()>=3 then
        local ct=Duel.Destroy(g,REASON_EFFECT)
        if ct>0 then
            if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then  return end
            local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
            if sg:GetCount()>=ct then
                local res=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,nil,ct,ct,e,tp)
                Duel.SpecialSummon(res,0,tp,tp,false,false,POS_FACEUP)
             end
         end  
    end
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckLPCost(c:GetControler(),1000)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,1000)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(1500)
    e1:SetReset(RESET_PHASE+0x1fe0000)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(1250)
    e2:SetReset(RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
end
function s.sdcon(e)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end