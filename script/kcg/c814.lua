--クリボー
function c814.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40640057,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c814.con)
	e1:SetCost(c814.cost)
	e1:SetOperation(c814.op)
	c:RegisterEffect(e1)

	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c814.atkcon)
	e2:SetOperation(c814.atkop)
	c:RegisterEffect(e2)
end
function c814.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c814.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c814.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end

function c814.cfilter(c)
	return c:IsCode(40640057) and c:IsFaceup()
end
function c814.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker() and Duel.GetAttacker():GetControler()==1-tp and Duel.IsExistingMatchingCard(c814.cfilter,tp,LOCATION_MZONE,0,1,c) 
end
function c814.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() and Duel.GetAttacker():GetControler()==1-tp then
	Duel.NegateAttack() end
end