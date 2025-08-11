--黑魔导·红将
function c77239080.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239080.spcon)
	e1:SetOperation(c77239080.spop)
	c:RegisterEffect(e1)
	
    --直接攻击
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239080,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239080.cost)	
    e2:SetOperation(c77239080.datop)
    c:RegisterEffect(e2)
	
	--效果无效
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239080,1))	
	e3:SetType(EFFECT_TYPE_QUICK_F)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAINING)	
	e3:SetCountLimit(1)	
	e3:SetCondition(c77239080.condition)
	e3:SetTarget(c77239080.target)
	e3:SetOperation(c77239080.activate)
	c:RegisterEffect(e3)
end
--------------------------------------------------------------------------
function c77239080.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0		
end
function c77239080.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-500)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77239080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c77239080.datop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DIRECT_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
-------------------------------------------------------------------------
function c77239080.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
function c77239080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239080.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

