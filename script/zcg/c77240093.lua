--森之精灵的愤怒
function c77240093.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77240093.target)
    e1:SetOperation(c77240093.activate)
    c:RegisterEffect(e1)
end
function c77240093.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240093.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c77240093.filter,tp,0,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(c77240093.filter,tp,0,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240093.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77240093.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end
