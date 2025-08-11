--余码语者·扩展（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2)
--Name change on the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(40669071)
	c:RegisterEffect(e1)
--act limit
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCountLimit(1,id)
	e10:SetCondition(s.lzcon)
	e10:SetTarget(s.target)
	e10:SetOperation(s.operation)
	c:RegisterEffect(e10)
 --atk up/indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetProperty(0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function s.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetValue(s.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetValue(s.aclimit2)
	else
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetValue(s.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function s.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

