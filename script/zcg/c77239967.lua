--黑魔导女孩 红辣妹
function c77239967.initial_effect(c)
    --flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239967,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetTarget(c77239967.target)
    e1:SetOperation(c77239967.activate)
    c:RegisterEffect(e1)
end
function c77239967.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239967.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c77239967.filter,tp,0,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(c77239967.filter,tp,0,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239967.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239967.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end
