--胡狼神之法老(ZCG)
function c77238290.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c77238290.spop)
    c:RegisterEffect(e1)
	
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10000000,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetCost(c77238290.cost)
    e2:SetTarget(c77238290.target)
    e2:SetOperation(c77238290.activate)
    c:RegisterEffect(e2)	
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_SUMMON)
    e3:SetTargetRange(1,1)
    e3:SetRange(LOCATION_MZONE)	
    e3:SetTarget(c77238290.splimit)
    c:RegisterEffect(e3)
	local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e4)
end
---------------------------------------------------------------------
function c77238290.spop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
---------------------------------------------------------------------
function c77238290.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c77238290.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77238290.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77238290.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsAttribute(ATTRIBUTE_DIVINE)
end
