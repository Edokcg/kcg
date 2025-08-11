--碎魂者 熔海邪神(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	if aux.IsKCGScript then
		e1:SetValue(SUMMON_TYPE_TRIBUTE)
	else
		e1:SetValue(SUMMON_TYPE_ADVANCE)
	end
	c:RegisterEffect(e1)
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)	
	local e19=Effect.CreateEffect(c)
	e19:SetCategory(CATEGORY_REMOVE)
	e19:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e19:SetCode(EVENT_SUMMON_SUCCESS)
	e19:SetTarget(s.destg)
	e19:SetOperation(s.desop)
	c:RegisterEffect(e19)   
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.desreptg)
	e4:SetOperation(s.desrepop)
	c:RegisterEffect(e4)	
	 --summon
	local e91=Effect.CreateEffect(c)
	e91:SetType(EFFECT_TYPE_SINGLE)
	e91:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e91:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e91)
	local e92=Effect.CreateEffect(c)
	e92:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e92:SetCode(EVENT_SUMMON_SUCCESS)
	e92:SetTarget(s.tg92)
	e92:SetOperation(s.op92)
	c:RegisterEffect(e92)
	local e93=Effect.CreateEffect(c)
	e93:SetType(EFFECT_TYPE_FIELD)
	e93:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e93:SetCode(EFFECT_FORBIDDEN)
	e93:SetRange(LOCATION_MZONE)
	e93:SetTargetRange(0,0xff)
	e93:SetTarget(s.bantg93)
	c:RegisterEffect(e93)
	local e94=Effect.CreateEffect(c)
	e94:SetType(EFFECT_TYPE_SINGLE)
	e94:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e94:SetRange(LOCATION_MZONE)
	e94:SetCode(EFFECT_IMMUNE_EFFECT)
	e94:SetValue(s.efilter94)
	c:RegisterEffect(e94)
end
function s.repfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.repfilter,tp,0,LOCATION_MZONE,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,0,LOCATION_MZONE,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.filter(c)
	return c:IsAttackBelow(3000) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local sum=0
		for c in aux.Next(dg) do
			sum=sum+math.max(c:GetAttack(),0)
		end
		if sum>0 then
			Duel.Recover(tp,math.floor(sum/2),REASON_EFFECT)
		end
	end
end

function s.efilter94(e,te)
	return te:GetHandler():IsSetCard(0xa70)
end
function s.bantg93(e,c)
	return c:IsSetCard(0xa70) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function s.filter99(c)
	return c:IsSetCard(0xa70)
end
function s.tg92(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter99,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter99,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end

function s.op92(e, tp, eg, ep, ev, re, r, rp)
	local sg=Duel.GetMatchingGroup(s.filter99,tp,0,LOCATION_ONFIELD,nil)
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

