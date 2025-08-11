--千年积木
function c77238291.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238291.target)	
    c:RegisterEffect(e1)
	
    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)	
	
    --damage reduce
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(1,0)
    e3:SetValue(c77238291.damval2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e4)

    --selfdes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EFFECT_SELF_DESTROY)
    e5:SetCondition(c77238291.descon)
    c:RegisterEffect(e5)	
end
-------------------------------------------------------------------
function c77238291.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():SetTurnCounter(0)
end
-------------------------------------------------------------------
function c77238291.damval2(e,re,val,r,rp,rc)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+val/100
    c:SetTurnCounter(ct)
    return 0
end
-------------------------------------------------------------------
function c77238291.descon(e)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    return ct>49
end
