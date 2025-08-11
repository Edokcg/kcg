--青眼白龙 仪式
function c77239136.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon from hand
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(c77239136.hspcon)
    e1:SetOperation(c77239136.hspop)
    c:RegisterEffect(e1)

    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239136,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239136.atkcost)
    e2:SetOperation(c77239136.atkop)
    c:RegisterEffect(e2)	
end
------------------------------------------------------------------
function c77239136.ssfilter(c)
    return c:IsReleasable() and c:IsCode(77239135)
end
function c77239136.hspcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.CheckReleaseGroup(c:GetControler(),c77239136.ssfilter,1,nil)
end
function c77239136.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239136.ssfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
------------------------------------------------------------------
function c77239136.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,e:GetHandler(),77239135) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,e:GetHandler(),77239135)
    Duel.Release(g,REASON_COST)
end
function c77239136.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(500)
        e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e2:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e2)		
    end
end

