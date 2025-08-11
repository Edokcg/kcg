--奥利哈刚 托利托斯(ZCG)
function c77239263.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c77239263.con)
	e0:SetTarget(c77239263.target1) 
	e0:SetOperation(c77239263.activate1)	
	c:RegisterEffect(e0)


	--不受对方魔法陷阱影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c77239263.efilter)
	c:RegisterEffect(e1)
  
	--不能发动魔法卡
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c77239263.aclimit)
	c:RegisterEffect(e2) 
	
	--不会被破坏
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)	
end
---------------------------------------------------------------------------------
function c77239263.filter(c)
	return c:GetOriginalCodeRule()==48179391
end
function c77239263.filter1(c)
	return c:GetOriginalCodeRule()==110000100
end
function c77239263.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end 
end
function c77239263.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239263.filter,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(c77239263.filter1,tp,LOCATION_GRAVE,0,nil)
	g:Merge(g1)
		Duel.Overlay(e:GetHandler(),g)  
	e:GetHandler():CopyEffect(77239261,1)		 
	e:GetHandler():CopyEffect(77239262,1) 
end
function c77239263.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(110000100,tp)
end
---------------------------------------------------------------------------------
function c77239263.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
---------------------------------------------------------------------------------
function c77239263.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end

