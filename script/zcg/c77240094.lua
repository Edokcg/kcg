--森之精灵的回馈
function c77240094.initial_effect(c)
    --Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetCondition(c77240094.condition)
    e1:SetOperation(c77240094.drop)
    c:RegisterEffect(e1)
end

function c77240094.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c77240094.drop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_REFLECT_DAMAGE)
    e1:SetTargetRange(1,0)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end