--神之对决(ZCG)
function c77239079.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239079.target)
    e1:SetOperation(c77239079.activate)
    c:RegisterEffect(e1)
end
function c77239079.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239079.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
    local t=Duel.Destroy(sg,REASON_EFFECT)
    if t>0 then
        Duel.Damage(tp,t*400,REASON_EFFECT)
		Duel.Damage(1-tp,t*400,REASON_EFFECT)
    end
end
