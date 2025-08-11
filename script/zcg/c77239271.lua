--奥利哈刚 雷电灭世(ZCG)
function c77239271.initial_effect(c)
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239271.target)
    e1:SetOperation(c77239271.activate)
    c:RegisterEffect(e1)
end
function c77239271.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return ep~=tp and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239271.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
