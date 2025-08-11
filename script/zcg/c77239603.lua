--植物的愤怒 狂树虎
function c77239603.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,77239630,77239621,false,false)
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	

	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77239603.val)
	c:RegisterEffect(e2)	
	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) 
	e3:SetCondition(c77239603.condition)
	e3:SetTarget(c77239603.target)
	e3:SetOperation(c77239603.activate)
	c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239603.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)*500
end
------------------------------------------------------------------
function c77239603.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239603.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77239603.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239603.filter,tp,LOCATION_DECK,0,1,nil)
	or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
function c77239603.activate(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local sg=Duel.GetMatchingGroup(c77239603.filter,tp,LOCATION_DECK,0,nil)
	if h1>0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)	   
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
	if h1==0 and sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c77239603.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end


