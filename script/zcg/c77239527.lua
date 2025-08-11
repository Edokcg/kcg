--女子佣兵 子龙(ZCG)
function c77239527.initial_effect(c)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239527,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    --e1:SetCondition(c77239527.condition)
    e1:SetOperation(c77239527.operation)
    c:RegisterEffect(e1)

    --activate cost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ACTIVATE_COST)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,1)
    e2:SetTarget(c77239527.actarget)
    e2:SetCondition(c77239527.actcon)	
    e2:SetCost(c77239527.costchk)
    e2:SetOperation(c77239527.costop)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------
--[[function c77239527.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end]]
function c77239527.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=c:GetMaterial():GetFirst():GetPreviousAttackOnField()
        if atk<0 then atk=0 end
        if atk>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(atk)
            e1:SetReset(RESET_EVENT+0x1ff0000)
            c:RegisterEffect(e1)
        end
    end
end
-----------------------------------------------------------
function c77239527.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239527.actarget(e,te,tp)
    return te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239527.costchk(e,te_or_c,tp)
    return Duel.CheckLPCost(tp,2000)
end
function c77239527.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,77239527)
    Duel.PayLPCost(tp,2000)
end




