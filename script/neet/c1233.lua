--混沌之极爆裂(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Apply various lingering effects to your "Blue-Eyes White Dragon"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)	
end
s.listed_names={CARD_BLUEEYES_W_DRAGON}
s.listed_series={0xdd}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--Cannot be destroyed by battle
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		--Cannot be destroyed by card effects
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
	Duel.BreakEffect()
	if tc:IsCode(CARD_BLUEEYES_W_DRAGON) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
	if tc:IsType(TYPE_FUSION) and tc:GetEffectCount(EFFECT_EXTRA_ATTACK)==0 then 
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(id,2))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_EXTRA_ATTACK)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(2)
		tc:RegisterEffect(e4)
	end
	if tc:IsType(TYPE_RITUAL) then
		local g=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function s.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end