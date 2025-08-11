--大爆炸暴风
function c77239060.initial_effect(c)
    --被破坏时清场
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239060.condition)
    e1:SetTarget(c77239060.target)
    e1:SetOperation(c77239060.operation)
    c:RegisterEffect(e1)
end
function c77239060.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler() and e:GetHandler():IsReason(REASON_BATTLE)
end
function c77239060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239060.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local sum=g:GetSum(Card.GetAttack)
	Duel.Damage(1-tp,sum,REASON_EFFECT)		
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g1,REASON_EFFECT)
	local sum1=g1:GetSum(Card.GetAttack)
	Duel.Damage(tp,sum1,REASON_EFFECT)			
end
