--地狱之黑魔導女孩(ZCG)
function c77239969.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
	
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239969,0))
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c77239969.cost)	
    e2:SetTarget(c77239969.target)
    e2:SetOperation(c77239969.operation)
    c:RegisterEffect(e2)
end
-----------------------------------------------------------------------------------
function c77239969.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c77239969.filter(c)
    return c:IsFaceup() and c:IsAttackAbove(0)
end
function c77239969.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239969.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77239969.filter,tp,0,LOCATION_MZONE,nil)
    local rec=g:GetSum(Card.GetAttack)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c77239969.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
