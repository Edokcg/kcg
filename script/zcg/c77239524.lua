--女子佣兵 初音(ZCG)
function c77239524.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239524.destg)
    e1:SetOperation(c77239524.desop)
    c:RegisterEffect(e1)
	
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239524.drcon)	
    e2:SetTarget(c77239524.target2)
    e2:SetOperation(c77239524.activate2)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------------------------------
function c77239524.filter(c,tp)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)    
end
function c77239524.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239524.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c77239524.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239524.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239524.filter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
-------------------------------------------------------------------------------------
function c77239524.cfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77239524.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c77239524.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239524.cfilter,tp,LOCATION_GRAVE,0,1,nil)  end
end
function c77239524.activate2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local dam=Duel.GetMatchingGroupCount(c77239524.cfilter,tp,LOCATION_GRAVE,0,nil)*1000
    if Duel.Damage(1-tp,dam,REASON_EFFECT) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetCode(EFFECT_SKIP_BP)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end


