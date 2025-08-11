--Attack Guidance Armor
function c725.initial_effect(c)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c725.atktg)
	e1:SetOperation(c725.atkop)
	c:RegisterEffect(e1)
end
function c725.filter(c)
	return (not Duel.GetAttacker() or c~=Duel.GetAttacker()) and c~=Duel.GetAttackTarget()
end
function c725.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg and tg:IsOnField() and not tg:IsStatus(STATUS_ATTACK_CANCELED) end
end
function c725.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetAttacker()
	if not (tg and tg:IsOnField() and not tg:IsStatus(STATUS_ATTACK_CANCELED)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c725.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eg:GetFirst())
	local tc=g:GetFirst()
	if tc then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_ATTACK)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetTargetRange(1,1)
		Duel.RegisterEffect(e1,tp)
		Duel.ChangeAttackTarget(tc,true)
    end
end