--奥利哈刚 翼神龙(ZCG)
function c77239233.initial_effect(c)
	--通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239233.ttcon)
	e1:SetOperation(c77239233.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77239233.setcon)
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
	e4:SetCondition(c77239233.spcon)
	e4:SetOperation(c77239233.spop)
	c:RegisterEffect(e4)
	
	--抗性
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c77239233.efilter)
	c:RegisterEffect(e7)

	--攻防提升
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c77239233.atkval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77239233.defval)
	c:RegisterEffect(e6)
	
	--不会被破坏
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239233,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
	e8:SetOperation(c77239233.desop1)
	c:RegisterEffect(e8)

	--提升攻击力
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77239233,1))
	e9:SetCategory(CATEGORY_ATKCHANGE)  
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
	e9:SetTarget(c77239233.target)
	e9:SetOperation(c77239233.desop)
	c:RegisterEffect(e9)
	
	--除外
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77239233,2))	
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)   
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c77239233.cost)
	e10:SetTarget(c77239233.target1)
	e10:SetOperation(c77239233.activate)
	c:RegisterEffect(e10)   
end
----------------------------------------------------------
function c77239233.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239233.spop(e,tp,eg,ep,ev,re,r,rp,c)
	  local c=e:GetHandler()
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
----------------------------------------------------------
function c77239233.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239233.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239233.setcon(e,c,minc)
	if not c then return true end
	return false
end
---------------------------------------------------------
function c77239233.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local atk=g:GetSum(Card.GetAttack)
	return math.ceil(atk)
end
function c77239233.defval(e,c)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local def=g:GetSum(Card.GetDefense)
	return math.ceil(def)
end
---------------------------------------------------------
function c77239233.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------
function c77239233.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e6=e9:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end
---------------------------------------------------------
function c77239233.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
end
function c77239233.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local LP=Duel.GetLP(1-tp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		if Duel.Release(sg,REASON_EFFECT) then
			local tc=sg:GetFirst()
			local atk=0
			local def=0
			while tc do
				local catk=tc:GetAttack()
				atk=atk+(catk>=0 and catk or 0)
				local cdef=tc:GetDefense()
				def=def+(cdef>=0 and cdef or 0)
				tc=sg:GetNext()
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk+LP-1)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(def+LP-1)
			c:RegisterEffect(e2)
		end
	end
	Duel.SetLP(1-tp,1)
end
--------------------------------------------------------
function c77239233.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c77239233.filter(c)
	return c:IsAbleToRemove()
end
function c77239233.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c77239233.filter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77239233.filter,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239233.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
