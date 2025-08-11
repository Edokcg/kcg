--光之金字塔
local s,id=GetID()
function s.initial_effect(c)

	--除外场上所有神属性怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--离场时除外斯芬克斯双怪
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.leave)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(s.desreptg)
	c:RegisterEffect(e3)

	--不受我方卡片效果影响
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_ULTIMATE_IMMUNE)
	c:RegisterEffect(e10)

	--神属性怪兽除外
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetCondition(s.con)
	e8:SetOperation(s.activate2)
	c:RegisterEffect(e8)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.efilter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_RULE+REASON_EFFECT)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.filter(c)
	local code=c:GetCode()
	return c:IsFaceup() and (code==15013468 or code==51402177) and aux.TRUE
end

function s.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousPosition(POS_FACEUP) then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsReason(REASON_REPLACE)
	end
	if c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		return true
	else return false end
end

function s.immune(e,te)
	return e:GetHandlerPlayer()~=1-te:GetHandlerPlayer()
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_RULE+REASON_EFFECT)
	end
end