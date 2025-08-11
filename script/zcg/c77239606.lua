--植物的愤怒 五齿花
function c77239606.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xa90),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xa90),1,99)
	c:EnableReviveLimit()

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239606,0)) 
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c77239606.target)
	e1:SetOperation(c77239606.activate)
	c:RegisterEffect(e1)	
end
-----------------------------------------------------------------
function c77239606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function c77239606.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if h1>0 and h2>0 then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end

