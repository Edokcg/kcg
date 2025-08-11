--朱罗纪五角龙-新炎狱
function c1639.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1639,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1639.remcon)
	e1:SetTarget(c1639.remtg)
	e1:SetOperation(c1639.remop)
	c:RegisterEffect(e1)
	--ban activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1639,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1639.bacon)
	e2:SetCost(c1639.bacost)
	e2:SetOperation(c1639.baop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1639,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(2)
	e3:SetCondition(c1639.atcon)
	e3:SetOperation(c1639.atop)
	c:RegisterEffect(e3)
end
function c1639.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c1639.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_GRAVE)
end
function c1639.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c1639.bacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1639.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c1639.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1639.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1639.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c1639.baop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c1639.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable(0)
		and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c1639.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end







