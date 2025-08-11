--真红的保护
function c77238794.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --不能发动效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c77238794.aclimit)
    c:RegisterEffect(e1)
	
    --selfdes
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCode(EFFECT_SELF_DESTROY)
    e7:SetCondition(c77238794.descon)
    c:RegisterEffect(e7)
end

function c77238794.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end

function c77238794.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c77238794.descon(e)
    return not Duel.IsExistingMatchingCard(c77238794.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

