--究極宝玉神 レインボー·ドラゴン
function c156.initial_effect(c)
	c:EnableReviveLimit()

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c156.spcon)
	c:RegisterEffect(e1)

	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)

	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e02:SetCode(EVENT_ADJUST)
	e02:SetRange(LOCATION_MZONE)	
	e02:SetCondition(c156.adcon)
	e02:SetOperation(c156.adoperation)
	c:RegisterEffect(e02)   

	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(79856792,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c156.atcon)
	e3:SetCost(c156.atcost)
	e3:SetOperation(c156.atop)
	c:RegisterEffect(e3)

	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	  e4:SetCondition(c156.desrepcon)
	e4:SetTarget(c156.desreptg)
	e4:SetOperation(c156.desrepop)
	c:RegisterEffect(e4)

	--todeck
	--local e4=Effect.CreateEffect(c)
	--e4:SetCategory(CATEGORY_TODECK)
	--e4:SetDescription(aux.Stringid(79856792,1))
	--e4:SetType(EFFECT_TYPE_IGNITION)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCondition(c156.tdcon)
	--e4:SetCost(c156.tdcost)
	--e4:SetTarget(c156.tdtg)
	--e4:SetOperation(c156.tdop)
	--c:RegisterEffect(e4)

	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c156.spop)
	c:RegisterEffect(e5)
end

function c156.spfilter(c)
	return (c:IsSetCard(0x1034) or c:IsSetCard(0x5034)) and (not c:IsOnField() or c:IsFaceup()) 
	  and Duel.IsExistingMatchingCard(c156.ffilter,c:GetControler(),LOCATION_SZONE,LOCATION_SZONE,1,nil) 
end
function c156.ffilter(c)
	return c:IsCode(12644061) and c:IsFaceup()
end
function c156.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c156.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	  if g:GetCount()>0 then
	local ct=g:GetClassCount(Card.GetCode)
	return ct>6 end
end

function c156.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(156,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end

function c156.adcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c156.spfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
	  local ct=g:GetClassCount(Card.GetCode)
	return ct<7 end
end
function c156.adoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)   
end

function c156.atcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(156)~=0 then return false end
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c156.afilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1034) or c:IsSetCard(0x5034)) and c:IsAbleToGraveAsCost()
end
function c156.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c156.afilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c156.afilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c156.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end

function c156.desrepcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(156)==0
end
function c156.repfilter(c)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) 
	  and (c:IsSetCard(0x1034) or c:IsSetCard(0x5034)) and c:IsFaceup() 
end
function c156.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c156.repfilter,tp,LOCATION_SZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,HINTMSG_DESREPLACE) then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c156.repfilter,tp,LOCATION_SZONE,0,1,1,nil)
		if #g<1 then return false end
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c156.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

function c156.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79856792)==0
end
function c156.cfilter(c)
	return (c:IsSetCard(0x1034) or c:IsSetCard(0x5034)) and c:IsAbleToRemoveAsCost() and c:IsFaceup() 
end
function c156.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c156.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c156.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c156.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c156.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
