--地缚神-A地带(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
       --cannot select battle target
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetTarget(s.immtg)
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
  --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.srtg)
    e2:SetOperation(s.srop)
    c:RegisterEffect(e2)
end
function s.immtg(e,c)
    return c:IsSetCard(0x21) and c:IsType(TYPE_MONSTER)
end
function s.srfilter(c)
    return c:IsSetCard(0x21) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end