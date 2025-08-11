--グランエルＧ3 
local s, id = GetID()
function s.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon2)
	c:RegisterEffect(e1)

	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000064,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.cbcon)
	e2:SetTarget(s.cbtg)
	e2:SetOperation(s.cbop)
	c:RegisterEffect(e2)

	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55888045,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end
s.listed_series={0x3013}

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3013)
end
function s.sdcon2(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=Duel.GetAttackTarget()
	return c~=bt and bt:GetControler()==c:GetControler()
end
function s.spfilter(c,e,tp)
	if c:GetEquipTarget()~=nil then
	return c:IsFaceup() and c:GetEquipTarget():IsSetCard(0x3013) and c:IsOriginalType(TYPE_MONSTER) and Duel.GetAttackTarget()~=c end
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc2=Duel.GetFirstTarget()
	if tc2 and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_EQUIP_MONSTER)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc2:RegisterEffect(e11)			
		  --immune
		--   local e121=Effect.CreateEffect(c)
		--   e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		--   e121:SetType(EFFECT_TYPE_SINGLE)
		--   e121:SetRange(LOCATION_MZONE)
		--   e121:SetCode(EFFECT_IMMUNE_EFFECT)
		--   e121:SetValue(s.efilter)
		--   e121:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		--   c:RegisterEffect(e121)
		--   local e5=e121:Clone()
		--   e5:SetCode(EFFECT_CHANGE_CODE)
		--   e5:SetValue(tc2:GetCode())
		--   c:RegisterEffect(e5)
		--   local e6=e121:Clone()
		--   e6:SetCode(EFFECT_SET_BASE_ATTACK)
		--   e6:SetValue(tc2:GetBaseAttack())
		--   c:RegisterEffect(e6)
		--   local e7=e121:Clone()
		--   e7:SetCode(EFFECT_SET_BASE_DEFENSE)
		--   e7:SetValue(tc2:GetBaseDefense())
		--   c:RegisterEffect(e7)
		--   local e8=e121:Clone()
		--   e8:SetCode(EFFECT_CHANGE_TYPE)
		--   e8:SetValue(tc2:GetOriginalType())
		--   c:RegisterEffect(e8)
		  Duel.ChangeAttackTarget(tc2)	 
   end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
end
