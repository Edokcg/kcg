--巨神兵 海马的灵魂
function c77239871.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239871.spcon)
    e2:SetOperation(c77239871.spop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --summon success
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c77239871.sumsuc)
    c:RegisterEffect(e4)
	
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c77239871.val)
    c:RegisterEffect(e5)

    --indestructable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(c77239871.infilter)
    e6:SetValue(1)
    c:RegisterEffect(e6)	
end
---------------------------------------------------------------------------
function c77239871.tlimit(c)
    return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4)
end
function c77239871.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.CheckReleaseGroup(c:GetControler(),c77239871.tlimit,3,nil)
end
function c77239871.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239871.tlimit,3,3,nil)
    Duel.Release(g,REASON_COST)
end
---------------------------------------------------------------------------
function c77239871.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
---------------------------------------------------------------------------
function c77239871.val(e,c)
    return Duel.GetMatchingGroupCount(c77239871.filter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)*400
end
function c77239871.filter(c)
    return c:IsType(TYPE_MONSTER)
end
---------------------------------------------------------------------------
function c77239871.infilter(e,c)
    return c:IsFaceup() and c:IsLevelBelow(4)
end



