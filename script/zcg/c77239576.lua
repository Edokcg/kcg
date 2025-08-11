--Flower Garden
function c77239576.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239576.cost)	
    e1:SetOperation(c77239576.activate)
    c:RegisterEffect(e1)
end
function c77239576.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
end
function c77239576.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77239576.attg)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77239576.attg(e,c,tp,eg,ep,ev,re,r,rp)
    return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end