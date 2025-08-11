--火光之壁(ZCG)
function c77239069.initial_effect(c)
   --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e3)
	
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(c77239069.damval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e2)	
end
function c77239069.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0
    else return val end
end