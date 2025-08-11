--卡通树精(ZCG)
local s,id=GetID()
function s.initial_effect(c)
 c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.sdescon)
	e3:SetOperation(s.sdesop)
	c:RegisterEffect(e3)
	
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.dircon)
	c:RegisterEffect(e4)

	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_CONTROL)	
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)	
	
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetCondition(s.sdcon)
	c:RegisterEffect(e6)	
end
function s.dirfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.dircon(e)
	return  not Duel.IsExistingMatchingCard(s.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
--------------------------------------------------------------------
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and ft>0
end
--------------------------------------------------------------------
function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousCodeOnField()==15259703 or c:GetPreviousCodeOnField()==900000079 or c:GetPreviousCodeOnField()==511001251  ) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--------------------------------------------------------------------
function s.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
--------------------------------------------------------------------
function s.spfilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
--------------------------------------------------------------------
function s.sdfilter(c)
	return c:IsSetCard(0x62)
end
function s.sdcon(e)
	return not Duel.IsExistingMatchingCard(s.sdfilter,0,LOCATION_GRAVE,0,1,nil)
end

