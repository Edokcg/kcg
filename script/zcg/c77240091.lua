--融合前线基地
function c77240091.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    --e1:SetCondition(c77240091.condition)
    c:RegisterEffect(e1)

    --selfdes
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCode(EFFECT_SELF_DESTROY)
    e7:SetCondition(c77240091.descon)
    c:RegisterEffect(e7)

    --avoid damage
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_CHANGE_DAMAGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(1,0)
    --e4:SetCondition(c77240091.condition1)
    e4:SetValue(c77240091.damval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e5)
end
-----------------------------------------------------------------
function c77240091.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
--[[function c77240091.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77240091.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end]]
------------------------------------------------------------------
function c77240091.descon(e)
    return not Duel.IsExistingMatchingCard(c77240091.cfilter,0,LOCATION_ONFIELD,0,1,nil)
end
------------------------------------------------------------------
--[[function c77240091.condition1(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end]]
function c77240091.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end