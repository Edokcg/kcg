--神之战(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chck) end
	local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local b1=ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2)
	local b2=true
	local b3=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)>0
	if chk==0 then return (b1 or b2 or b3) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
	elseif op==2 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,#sg,0,0)		
	end 
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op==1 then
		local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ht<6 then 
			Duel.Draw(tp,6-ht,REASON_EFFECT)
		end
		ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
		if ht<6 then 
			Duel.Draw(1-tp,6-ht,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Damage(1-tp,4000,REASON_EFFECT)
	else
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if Duel.GetTurnPlayer()==tp then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_SKIP_M2)
		e0:SetTargetRange(1,0)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.ftarget)
		e1:SetLabel(tc:GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,3),nil)
	end
end
function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end