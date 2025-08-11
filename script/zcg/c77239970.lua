--决斗盔甲·黑魔导装(ZCG)
function c77239970.initial_effect(c)
	--synchro summon
	if aux.IsKCGScript then
        Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),2,99)
    else
        aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
    end
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77239970.con)
	e1:SetOperation(c77239970.negop)
	c:RegisterEffect(e1)
	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239970,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTarget(c77239970.target)
	e2:SetOperation(c77239970.activate)
	c:RegisterEffect(e2)
	
	--destroy replace
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77239970.reptg)
    e3:SetOperation(c77239970.reprop)
    c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(c77239970.efilter)
	e4:SetCondition(c77239970.spcon)
	c:RegisterEffect(e4)	
end
-----------------------------------------------------------------------------
function c77239970.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77239970.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetTurnPlayer()==tp then
		if Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetLabel(Duel.GetTurnCount())
		else
			e1:SetLabel(Duel.GetTurnCount()+2)
		end
	else
		e1:SetLabel(Duel.GetTurnCount()+1)
	end
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c77239970.retcon)
	e1:SetOperation(c77239970.retop)
	Duel.RegisterEffect(e1,tp)
end
function c77239970.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c77239970.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239970.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c77239970.filter(c,e,tp)
	return c:IsSetCard(0x1017) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
-----------------------------------------------------------------------------
function c77239970.filter1(c,e,tp)
	return (c:IsCode(77239080) or c:IsCode(77239081) or c:IsCode(77239082) or c:IsCode(77239085)) and c:IsAbleToGrave()
end
function c77239970.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239970.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
end
function c77239970.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77239970.filter1,p,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,63,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x1,g:GetCount())
	end
end
-----------------------------------------------------------------------------
function c77239970.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE+REASON_REPLACE)
	   and e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_EFFECT) end
   return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c77239970.reprop(e,tp,eg,ep,ev,re,r,rp)
	 e:GetHandler():RemoveCounter(tp,0x1,1,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239970.efilter(e,re,rp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c77239970.cfilter(c)
	return c:IsFaceup() and c:IsCode(46986414)
end
function c77239970.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77239970.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end



