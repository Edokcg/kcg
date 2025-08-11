--奥利哈刚 杰斯拉克(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	 --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(98710548,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.dmtg)
	e2:SetOperation(s.dmop)
	c:RegisterEffect(e2)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsSetCard(0xa50) and a:IsRelateToBattle())
		or (d:GetControler()==tp and d:IsSetCard(0xa50) and d:IsRelateToBattle()))
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) end
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(e:GetHandler():GetControler(),aux.TRUE,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		local dg=Duel.GetOperatedGroup()
		if Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) then
		local g2=Duel.SelectMatchingCard(e:GetHandler():GetControler(),Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,1,nil)
		local tc=g2:GetFirst()
		local atk=dg:GetFirst():GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atk)
	tc:RegisterEffect(e1)
end
	end 
end
