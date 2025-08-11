--三色虎
function c77240092.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18063928,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77240092.target)
    e1:SetOperation(c77240092.activate)
    c:RegisterEffect(e1)
end
function c77240092.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240092.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end

