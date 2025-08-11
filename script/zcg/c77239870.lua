--天空龙 游戏的正义
function c77239870.initial_effect(c)
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
    e2:SetCondition(c77239870.spcon)
    e2:SetOperation(c77239870.spop)
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
    e4:SetOperation(c77239870.sumsuc)
    c:RegisterEffect(e4)
	
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239870,0))
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetCost(c77239870.cost)
    e5:SetOperation(c77239870.atkop)
    c:RegisterEffect(e5)

    --redirect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetReset(RESET_EVENT+RESETS_REDIRECT)
    e6:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e6)
end
---------------------------------------------------------------------------
function c77239870.tlimit(c)
    return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4)
end
function c77239870.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.CheckReleaseGroup(c:GetControler(),c77239870.tlimit,3,nil)
end
function c77239870.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239870.tlimit,3,3,nil)
    Duel.Release(g,REASON_COST)
end
---------------------------------------------------------------------------
function c77239870.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
---------------------------------------------------------------------------
function c77239870.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c77239870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239870.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239870.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c77239870.atkfilter(c)
    return c:IsLevelAbove(4) and c:IsType(TYPE_MONSTER)
end
function c77239870.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239870.atkfilter,tp,LOCATION_GRAVE,0,nil)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(g:GetCount()*500)
    e:GetHandler():RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    e:GetHandler():RegisterEffect(e2)	
end
