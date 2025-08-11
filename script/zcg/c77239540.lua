--灵族的意识(ZCG)
function c77239540.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
	--不受效果影响
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c77239540.etarget)
    e2:SetValue(c77239540.efilter)
    c:RegisterEffect(e2)	
	
    --不会成为攻击对象
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e3:SetValue(c77239540.atlimit)
    c:RegisterEffect(e3)
end
---------------------------------------------------------------------------
function c77239540.atlimit(e,c)
    return c:IsFaceup() and c:IsSetCard(0xa81)
end
---------------------------------------------------------------------------
function c77239540.etarget(e,c)
    return c:IsSetCard(0xa81)
end
function c77239540.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end