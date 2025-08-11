--卡通地缚神
function c77240071.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240071.spcon)
    c:RegisterEffect(e1)

    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77240071.val)
    c:RegisterEffect(e2)

    --direct attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetCondition(c77240071.dircon)
    c:RegisterEffect(e4)	
end
-------------------------------------------------------------------
function c77240071.spfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240071.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240071.spfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
-------------------------------------------------------------------
function c77240071.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x62)
end
function c77240071.dircon(e)
    return not Duel.IsExistingMatchingCard(c77240071.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
-------------------------------------------------------------------
function c77240071.val(e,c)
    return Duel.GetMatchingGroupCount(c77240071.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*300
end
function c77240071.filter(c)
    return c:IsSetCard(0x62) or c:IsSetCard(0x21)
end




