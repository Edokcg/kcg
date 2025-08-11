--女子佣兵 圣魔师(ZCG)
function c77239511.initial_effect(c)
    --不能攻击
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetTarget(c77239511.tg)
    c:RegisterEffect(e1)
	
	--BUFF
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239511.cost)	
    e2:SetOperation(c77239511.op)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------
function c77239511.tg(e,c)
    return c:IsRace(RACE_SPELLCASTER)
end
-------------------------------------------------------------
function c77239511.costfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80) and c:IsAbleToGraveAsCost()
end
function c77239511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239511.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239511.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c77239511.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
    e2:SetValue(c77239511.efilter)
    c:RegisterEffect(e2)	
end
function c77239511.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

