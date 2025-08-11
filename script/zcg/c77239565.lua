--邪之于贝尔(ZCG)
function c77239565.initial_effect(c)
    --battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239565,1))
    e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239565.cost)
    e3:SetTarget(c77239565.target)
    e3:SetOperation(c77239565.activate)
    c:RegisterEffect(e3)	
end
function c77239565.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c77239565.filter(c)
    return c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c77239565.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239565.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c77239565.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239565.filter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst() 
	if Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)>0 then
        Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
    end
end