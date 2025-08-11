--吸血恐兽(ZCG)
function c77239158.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --[[summon cost
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SUMMON_COST)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,0xa)
    e3:SetCost(c77239158.costchk)
    e3:SetOperation(c77239158.costop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_SPSUMMON_COST)
    c:RegisterEffect(e4)]]
    
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239158,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77239158.descon)
    e2:SetOperation(c77239158.desop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end

--[[function c77239158.costchk(e,te_or_c,tp)
    return Duel.CheckLPCost(tp,500)
end
function c77239158.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,77239158)
    Duel.PayLPCost(tp,500)
end]]
function c77239158.descon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.CheckLPCost(rp,500)
end
function c77239158.desop(e,tp,eg,ep,ev,re,r,rp)
        Duel.PayLPCost(1-tp,500)
end