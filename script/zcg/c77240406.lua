--上古恶魔(ZCG)
local s,id=GetID()
function s.initial_effect(c)
							   --immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.splimit)
	c:RegisterEffect(e2)
 --avoid damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabel(0)
	e3:SetValue(s.damval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.atcon)
	e4:SetOperation(s.atop)
	c:RegisterEffect(e4)
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
	e2:SetValue(-_G["dam77240406"..num])
	c:RegisterEffect(e2)
end
function s.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local num=Duel.GetTurnCount()
	if val~=0 and e:GetHandler():GetAttack()>=val then
		_G["dam77240406"..num]=val
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
		return 0
	else return val end
end
function s.atkcon(e)
	return e:GetHandler():GetAttack()>=4000
end
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xa120)
end
function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end