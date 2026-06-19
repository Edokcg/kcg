--ダークネス １
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.cop)
	c:RegisterEffect(e2)
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,511310104),tp,LOCATION_SZONE,0,1,nil) or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,511310105),tp,LOCATION_SZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetChainLimit(s.climit)
end
function s.climit(e,lp,tp)
	return lp==tp
end
function s.filter(c)
	return c:IsSetCard(0x316) and c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.desfilter(c)
	return c:IsDestructable()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	s.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	return rc:IsSetCard(0x316) and re:IsSpellTrapEffect() and re:IsActiveType(TYPE_CONTINUOUS) 
	and c~=rc and c:GetFlagEffect(id)>0 and rc:IsOnField() and rc:IsControler(tp)
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,s.op2)
	local rc=re:GetHandler()
	if rc:IsContinuousSpellTrap() then
		rc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g<1 then return end
	Duel.Destroy(g,REASON_EFFECT)
end