--不死之栗子球
function c77238125.initial_effect(c)
    --no damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238125,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(c77238125.con)
    e1:SetCost(c77238125.cost)
    e1:SetOperation(c77238125.op)
    c:RegisterEffect(e1)
end
function c77238125.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c77238125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c77238125.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
    Duel.Damage(1-tp,e:GetHandler():GetAttack(),REASON_EFFECT)
end
