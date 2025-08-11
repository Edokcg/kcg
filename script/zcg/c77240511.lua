--妖歌·异约魂印之翼(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		   --avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atcon)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.atcon(e)
return e:GetHandler():GetFlagEffect(id)>0
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local num=Duel.GetTurnCount()
	c:ResetFlagEffect(id)
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(_G["dam77240511"..num])
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)

	_G["dam77240511"..num] = nil
end   
function s.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local num=Duel.GetTurnCount()
	if val~=0 and bit.band(r,REASON_EFFECT)~=0 then
		_G["dam77240511"..num]=val
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
		return 0
	else return val end
end