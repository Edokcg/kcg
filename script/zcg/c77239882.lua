--异次元胖丁
function c77239882.initial_effect(c)
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77239882.splimit)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991099,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c77239882.target)
	e2:SetOperation(c77239882.operation)
	c:RegisterEffect(e2)

	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239882.condition)
	e3:SetTarget(c77239882.destg)
	e3:SetOperation(c77239882.desop)
	c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------
function c77239882.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
-----------------------------------------------------------------------
function c77239882.sefilter(c)
	return c:IsAbleToDeck()
end
function c77239882.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239882.sefilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c77239882.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.SelectMatchingCard(tp,c77239882.sefilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if tc then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.BreakEffect()  
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
-----------------------------------------------------------------------
function c77239882.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0
end
function c77239882.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c77239882.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end





