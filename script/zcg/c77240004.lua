--闇の破壊神－ホルアクティ
function c77240004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c77240004.spcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	local e03=e1:Clone()
	e03:SetRange(LOCATION_HAND)
	c:RegisterEffect(e03)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--copy  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c77240004.operation1)
	c:RegisterEffect(e5)
	--[[atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(99999999)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(99999999)
	c:RegisterEffect(e7)]]
	--negate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77240004,0))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCondition(c77240004.condition)
	e8:SetTarget(c77240004.target)
	e8:SetOperation(c77240004.operation)
	c:RegisterEffect(e8)
	--counter
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77240004,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_CHAIN_DISABLED)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCondition(c77240004.con)
	e9:SetTarget(c77240004.tg)
	e9:SetOperation(c77240004.op)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e10)
end
function c77240004.filter(c,Code)
	return c:IsFaceup() and c:IsCode(Code)
end
function c77240004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c77240004.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,77239103)
		and Duel.IsExistingMatchingCard(c77240004.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,77239104)
		and Duel.IsExistingMatchingCard(c77240004.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,77239105)
end
function c77240004.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsType(TYPE_MONSTER)
end
function c77240004.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(c77240004.cfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end
function c77240004.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c77240004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c77240004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c77240004.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c77240004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local condition=re:GetCondition()
	local cost=re:GetCost()
	local target=re:GetTarget()
	if chk==0 then return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) 
		and (not target or target(e,tp,eg,ep,ev,re,r,rp,0)) end
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	Duel.ClearTargetCard()
	e:SetLabelObject(re)
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	if target and target(e,tp,eg,ep,ev,re,r,rp,0) then target(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c77240004.op(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
