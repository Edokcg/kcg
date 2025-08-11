--奥利哈刚 巨神兵(ZCG)
function c77239231.initial_effect(c)
	--通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239231.ttcon)
	e1:SetOperation(c77239231.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77239231.setcon)
	c:RegisterEffect(e2)
	
	--召唤不会被无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	
	--特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c77239231.spcon)
	e4:SetOperation(c77239231.spop)
	c:RegisterEffect(e4)	
	
	--抗性
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c77239231.efilter)
	c:RegisterEffect(e5)

	--破坏
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239231,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
	e6:SetCondition(c77239231.condition)
	e6:SetTarget(c77239231.target)  
	e6:SetOperation(c77239231.desop1)
	c:RegisterEffect(e6)
	
	--不会被破坏
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77239231,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
	e7:SetCondition(c77239231.condition)
	e7:SetOperation(c77239231.desop2)
	c:RegisterEffect(e7)

	--攻击力MAX
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239231,2))
	e8:SetCategory(CATEGORY_ATKCHANGE)  
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
	e8:SetCondition(c77239231.condition)
	e8:SetOperation(c77239231.desop3)
	c:RegisterEffect(e8)	
end
----------------------------------------------------------
function c77239231.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239231.spop(e,tp,eg,ep,ev,re,r,rp,c)
	  local c=e:GetHandler()
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
----------------------------------------------------------
function c77239231.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239231.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239231.setcon(e,c,minc)
	if not c then return true end
	return false
end
---------------------------------------------------------
function c77239231.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*2000
end
---------------------------------------------------------
function c77239231.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------
function c77239231.condition(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(Card.IsReleasable,c:GetControler(),0,LOCATION_MZONE,2,nil) or Duel.IsExistingMatchingCard(Card.IsReleasable,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c77239231.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239231.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,2,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,2,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
		local ops={}
		local opval={}
		local off=1
		if b1 then
		ops[off]=aux.Stringid(77239231,3)
		opval[off-1]=1
		off=off+1
		end
		if b2 then
		ops[off]=aux.Stringid(77239231,4)
		opval[off-1]=2
		off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,LOCATION_MZONE,0,2,2,nil,e,tp)
		Duel.Release(g,REASON_COST)
	else
		local g1=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,0,LOCATION_MZONE,2,2,nil,e,tp)
		Duel.Release(g1,REASON_COST)
	end 
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,5000,REASON_EFFECT)	
end
---------------------------------------------------------
function c77239231.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,2,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,2,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
		local ops={}
		local opval={}
		local off=1
		if b1 then
		ops[off]=aux.Stringid(77239231,3)
		opval[off-1]=1
		off=off+1
		end
		if b2 then
		ops[off]=aux.Stringid(77239231,4)
		opval[off-1]=2
		off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,LOCATION_MZONE,0,2,2,nil,e,tp)
		Duel.Release(g,REASON_COST)
	else
		local g1=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,0,LOCATION_MZONE,2,2,nil,e,tp)
		Duel.Release(g1,REASON_COST)
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)	
end
----------------------------------------------------------
function c77239231.desop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,2,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,2,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
		local ops={}
		local opval={}
		local off=1
		if b1 then
		ops[off]=aux.Stringid(77239231,3)
		opval[off-1]=1
		off=off+1
		end
		if b2 then
		ops[off]=aux.Stringid(77239231,4)
		opval[off-1]=2
		off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,LOCATION_MZONE,0,2,2,nil,e,tp)
		Duel.Release(g,REASON_COST)
	else
		local g1=Duel.SelectMatchingCard(tp,c77239231.filter11,tp,0,LOCATION_MZONE,2,2,nil,e,tp)
		Duel.Release(g1,REASON_COST)
	end
	local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INF_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end