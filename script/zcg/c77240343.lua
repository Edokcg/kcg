--卡通光与暗之龙(ZCG)
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
	--avoid atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(s.atcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.sdescon)
	e3:SetOperation(s.sdesop)
	c:RegisterEffect(e3)
--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetCondition(s.con)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
--Attribute Dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
  --Negate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetCategory(CATEGORY_NEGATE)
	e9:SetType(EFFECT_TYPE_QUICK_F)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.codisable)
	e9:SetTarget(s.tgdisable)
	e9:SetOperation(s.opdisable)
	c:RegisterEffect(e9)
end
function s.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and rp==1-tp
end
function s.relfilter(c)
return c:IsSetCard(0x62) and c:IsAbleToRemoveAsCost()
end
function s.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.NegateActivation(ev) then
	   Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousCodeOnField()==15259703 or c:GetPreviousCodeOnField()==900000079 or c:GetPreviousCodeOnField()==511001251  ) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)<5
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.cfilter2(c,code)
	return c:IsFaceup() and c:IsSetCard(0x62) and not c:IsCode(code)
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler():GetCode())
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()   
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end