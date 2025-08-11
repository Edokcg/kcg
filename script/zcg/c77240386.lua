--上古魔像(ZCG)
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
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atcon)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
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
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(-_G["dam77240386"..num])
	c:RegisterEffect(e2)
	if c:GetDefense()==0 then
		  e:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
		  Duel.Damage(1-tp,4000,REASON_EFFECT)
		  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	  end
end   
function s.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local num=Duel.GetTurnCount()
	if val~=0 then
		_G["dam77240386"..num]=val
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
		return 0
	else return val end
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