--上古龙王(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		c:EnableReviveLimit()
	--cannot special summon
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--negate
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(id,2))
	e20:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e20:SetType(EFFECT_TYPE_QUICK_O)
	e20:SetCode(EVENT_CHAINING)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCondition(s.condition2)
	e20:SetTarget(s.target2)
	e20:SetOperation(s.operation2)
	c:RegisterEffect(e20)
	--special summon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
function s.filter(c)
return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)==Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
end
function s.relfilter(c)
return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_DRAGON)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.NegateActivation(ev) then
	   Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.spfilter(c) 
return c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end 
function s.spcon(e, c)
	if c == nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
		Duel.GetMatchingGroupCount(s.spfilter, c:GetControler(), LOCATION_MZONE, 0, nil) == 3
end