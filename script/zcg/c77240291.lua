--装甲 前线大作战 （ZCG）
function c77240291.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240291,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77240291.reccon)
	e2:SetTarget(c77240291.rectg)
	e2:SetOperation(c77240291.recop)
	c:RegisterEffect(e2)
end
function c77240291.reccon(e,tp,eg,ep,ev,re,r,rp)
	return 1-tp==Duel.GetTurnPlayer()
end
function c77240291.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_MZONE)
end
function c77240291.recop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,2,2,nil)
   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end