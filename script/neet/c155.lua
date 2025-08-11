--トライエッジ・リヴァイア
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),4,4,s.ovfilter,aux.Stringid(id,0))
    aux.EnableCheckRankUp(c, nil, s.xyzop, s.xyzfilter)
	c:EnableReviveLimit()
    
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
    e2:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_RANKUP_EFFECT)
	e6:SetLabelObject(e2)	
	c:RegisterEffect(e6,false,EFFECT_MARKER_DETACH_XMAT)

    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.condition)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
    e4:SetLabelObject(e2)	
    c:RegisterEffect(e4)
end

function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:GetRank() == 3 and c:IsAttribute(ATTRIBUTE_WATER)
end

function s.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ)
end

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetDescription(3302)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or c:GetAttack()>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    e:GetHandler():RegisterFlagEffect(id, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	end
end