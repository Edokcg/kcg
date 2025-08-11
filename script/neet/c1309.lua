--幻影骑士团 折半刀（neet）
local s,id=GetID()
function s.initial_effect(c)
	 c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.mfilter,4,2)
--Direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--Reduce damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(s.rdcon)
	e3:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e3)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
 --LP
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetOperation(s.checkop)
	c:RegisterEffect(e4)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e30:SetProperty(EFFECT_FLAG_DELAY)
	e30:SetCountLimit(1,id)
	e30:SetCode(EVENT_DESTROYED)
	e30:SetLabelObject(e4)
	e30:SetCondition(s.thcond)
	e30:SetOperation(s.lpop)
	c:RegisterEffect(e30)
end
s.listed_series={0x10db}
function s.mfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_WARRIOR,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,lc,sumtype,tp)
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()/2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function s.thcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_TRIBUTE) and (c:IsReason(REASON_BATTLE) or rp==1-tp) and e:GetLabelObject():GetLabel()==0
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() or (not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x10db)) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
