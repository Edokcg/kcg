--奥利哈刚之怒(ZCG)
function c77239270.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetCondition(c77239270.condition)
    e1:SetTarget(c77239270.target)
    e1:SetOperation(c77239270.activate)
    c:RegisterEffect(e1)    
end
function c77239270.condition(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return d and d:IsFaceup() and d:IsControler(tp) and d:IsSetCard(0xa50)
end
function c77239270.filter(c)
    return c:IsAttackPos()
end
function c77239270.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239270.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77239270.filter,tp,0,LOCATION_MZONE,nil)
       local tc=g:GetFirst()
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239270.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239270.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*300,REASON_EFFECT)
    end
end
