--装甲 半械能改造 （ZCG）
function c77240296.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8279188,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c77240296.condition)
	e2:SetTarget(c77240296.target2)
	e2:SetOperation(c77240296.activate)
	c:RegisterEffect(e2)
end
function c77240296.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77240296.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and tg:IsOnField() and tg:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetTargetCard(tg)
end
function c77240296.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.NegateAttack()~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil) 
		local tc2=g:GetFirst()
		if not Duel.Equip(tp,tc,tc2,false) then return end
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c77240296.eqlimit)
		e1:SetLabelObject(tc2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(77240296,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(c77240296.atkval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2)
		end
	end
end
function c77240296.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c77240296.atkfilter(c)
return c:GetFlagEffect(77240296)>0
end
function c77240296.atkval(e,c)
	local eg=c:GetEquipGroup():Filter(c77240296.atkfilter,nil)
	local atk=eg:GetFirst():GetAttack()
	return atk 
end


