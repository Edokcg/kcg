--Sin レインボー·ドラゴン
function c88.initial_effect(c)
		c:EnableReviveLimit()
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(c88.spcon)
		e1:SetOperation(c88.spop)
		c:RegisterEffect(e1)

		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetCondition(c88.descon)
		c:RegisterEffect(e7)

		--spson
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e9:SetCode(EFFECT_SPSUMMON_CONDITION)
		e9:SetValue(aux.FALSE)
		c:RegisterEffect(e9)

	  --atkup
	  local e10=Effect.CreateEffect(c)
	  e10:SetCategory(CATEGORY_ATKCHANGE)
	  e10:SetDescription(aux.Stringid(79856792,0))
	  e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	  e10:SetType(EFFECT_TYPE_QUICK_O)
	  e10:SetCode(EVENT_FREE_CHAIN)
	  e10:SetHintTiming(TIMING_DAMAGE_STEP)
	  e10:SetRange(LOCATION_MZONE)
	  e10:SetCondition(c88.atcon)
	  e10:SetCost(c88.atcost)
	  e10:SetOperation(c88.atop)
	  c:RegisterEffect(e10)

	  --todeck
	  local e11=Effect.CreateEffect(c)
	  e11:SetCategory(CATEGORY_TODECK)
	  e11:SetDescription(aux.Stringid(79856792,1))
	  e11:SetType(EFFECT_TYPE_IGNITION)
	  e11:SetRange(LOCATION_MZONE)
	  e11:SetCost(c88.tdcost)
	  e11:SetTarget(c88.tdtg)
	  e11:SetOperation(c88.tdop)
	  c:RegisterEffect(e11)
end
c88.listed_names={27564031,79856792}

function c88.spfilter(c)
		return c:IsCode(79856792) and c:IsAbleToGraveAsCost()
end
function c88.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c88.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function c88.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c88.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if #tg<1 then return end
		Duel.SendtoGrave(tg,REASON_COST)
end

function c88.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end

function c88.destarget(e,c)
		return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end

function c88.antarget(e,c)
		return c~=e:GetHandler()
end

function c88.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c88.afilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c88.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88.afilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c88.afilter,tp,LOCATION_MZONE,0,e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c88.atop(e,tp,eg,ep,ev,re,r,rp)
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

function c88.cfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c88.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c88.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c88.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c88.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
