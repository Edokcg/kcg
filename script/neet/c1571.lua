--黑魔术咒文书(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x10a2,0x20a2}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsRace(RACE_SPELLCASTER) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.FaceupFilter(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(700)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,nil)
	local brk=0
	if tc:IsSetCard(0x10a2) and #g>0 then
		if brk==0 then Duel.BreakEffect() brk=1 end
		for sc in g:Iter() do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			sc:RegisterEffect(e1)
		end
	end
	local dg=Duel.GetMatchingGroup(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,nil)
	if tc:IsSetCard(0x20a2) and #dg>0 then
		if brk==0 then Duel.BreakEffect() brk=1 end
		--Negate the effects of all face-up monsters your opponent currently controls, until the end of this turn
		for dc in dg:Iter() do
			dc:NegateEffects(c,RESET_PHASE|PHASE_END)
		end
	end
end