--机械昆虫 魔蝎王(ZCG)
local s,id=GetID()
function s.initial_effect(c)
     --xyz summon
    if aux.IsKCGScript then
        Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),8,2)
    else
        aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),8,2)
    end
    c:EnableReviveLimit()
  --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(s.cost)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2) 
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(s.regop)
    c:RegisterEffect(e3)
 local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(s.thcost)
    e5:SetCondition(s.thcon)
    e5:SetTarget(s.thtg)
    e5:SetOperation(s.thop)
    c:RegisterEffect(e5)
        --
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(s.efilter)
    c:RegisterEffect(e11)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(id)<=0 and tp==Duel.GetTurnPlayer()
end
function s.thfilter(c,e,tp)
    return c:IsCode(77238028) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    --selfdes
    local c=e:GetHandler()
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_SELF_DESTROY)
    c:RegisterEffect(e7)
end 
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
     if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            tc=g:GetNext()
        end
        Duel.SpecialSummonComplete()
    end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
end
function s.efilter(e,te)
    local c=e:GetHandler()
    local ec=te:GetHandler()
    if ec:IsHasCardTarget(c) then return true end
    return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end