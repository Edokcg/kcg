--欧贝里斯克之铠甲-胸铠
function c77238502.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(c77238502.sumsuc)
    c:RegisterEffect(e3)
	
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c77238502.disable)
    e4:SetCondition(c77238502.con)
    c:RegisterEffect(e4)
end
-------------------------------------------------------------------------
function c77238502.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
-------------------------------------------------------------------------
function c77238502.con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()~=tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c77238502.disable(e,c)
    return c:IsType(TYPE_MONSTER) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end


