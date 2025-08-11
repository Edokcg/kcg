--上古奇美拉(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--tribute check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.valcheck)
	c:RegisterEffect(e4)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	--negate
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(id,1))
	e20:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e20:SetType(EFFECT_TYPE_QUICK_O)
	e20:SetCode(EVENT_CHAINING)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCondition(s.condition2)
	e20:SetTarget(s.target2)
	e20:SetOperation(s.operation2)
	c:RegisterEffect(e20)
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
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return  ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not re:GetHandler():IsSetCard(0xa120)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(500) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or c:GetAttack()<500
		or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		if Duel.NegateActivation(ev) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if res77240409==0 then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-2000)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
end
res77240409=nil
end
function s.checkfilter(c)
return not c:IsSetCard(0xa120)
end
function s.valcheck(e,c)
--[[local ct=g:FilterCount(s.checkfilter,nil)
	local res
	if ct>0 then
	res=0	
	else
	res=1   
	end
	e:SetLabel(res)]]
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	while tc do
	if not tc:IsSetCard(0xa120) then
		res77240409=0
		break  
	else
		res77240409=1
	end
	tc=g:GetNext()
	end
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