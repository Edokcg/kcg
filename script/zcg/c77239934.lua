--邪神 神化身亚瓦塔(ZCG)
function c77239934.initial_effect(c)
    --cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
	
    --summon with 3 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239934.ttcon)
    e1:SetOperation(c77239934.ttop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239934.setcon)
    c:RegisterEffect(e2)
	
    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(c77239934.sumsuc)
    c:RegisterEffect(e3)
	
    --direct attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e4)

    --match kill
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_MATCH_KILL)
    c:RegisterEffect(e5)	
end
-----------------------------------------------------------------------------------
function c77239934.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239934.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239934.setcon(e,c,minc)
    if not c then return true end
    return false
end
-----------------------------------------------------------------------------------
function c77239934.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    --actlimit
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c77239934.aclimit)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)	
    Duel.RegisterEffect(e1,tp)
end
function c77239934.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end

