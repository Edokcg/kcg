--反-深淵 (K)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_OVERLAY)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)   
end

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=eg:GetFirst()
	Duel.Hint(HINT_CARD,ep,352)
	if not eqc then return end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56840427,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.atkcon)
	e2:SetCost(s.atkcost)
	e2:SetOperation(s.atkop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	eqc:RegisterEffect(e2)
end

function s.atkfilter(c)
	return c:IsCode(511002157) and c:IsAbleToGraveAsCost()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsOnField() and at:IsFaceup() 
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsFaceup() and at:IsFaceup() then
		Duel.AdjustInstantly(a)
		local atk=a:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e1)
		--cannot destroyed
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e0)
	end
end