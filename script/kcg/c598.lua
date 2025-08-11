--垃圾栗子球 (K)
function c598.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40640057,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c598.condition)
	e1:SetTarget(c598.target)
	e1:SetOperation(c598.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c598.condition2)
	e2:SetTarget(c598.target2)
	e2:SetOperation(c598.activate2)
	c:RegisterEffect(e2)

	-- local e5=Effect.CreateEffect(c)
	-- e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_SUMMON_SUCCESS)
	-- e5:SetOperation(c598.atkop)
	-- c:RegisterEffect(e5)
	-- local e10=e5:Clone()
	-- e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e10)
	-- local e98=e5:Clone()
	-- e98:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	-- c:RegisterEffect(e98)
end

function c598.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c598.condition2(e,tp,eg,ep,ev,re,r,rp)
	  if re:GetHandler():IsDisabled() then return end
	--if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if not ex then return false end
	return (cp==tp or ep==PLAYER_ALL) and cv>=Duel.GetLP(tp) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c598.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
end
function c598.activate(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	 if c:IsRelateToEffect(e) then
	  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	  Duel.BreakEffect()
	  if Duel.GetBattleDamage(tp)>=Duel.GetLP(tp) then
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)  
	  local atker=Duel.GetAttacker()
	  local atked=Duel.GetAttackTarget()
	  if atker==nil then return end
	  if atker:IsControler(tp) and atked~=nil and atked:IsOnField() then 
	  Duel.Destroy(atked,REASON_EFFECT) end
	  if atker:IsControler(1-tp) and atker:IsOnField() then 
	  Duel.Destroy(atker,REASON_EFFECT) end end end
end
function c598.activate2(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	  if ex or re:GetHandler():IsDisabled() or not ((cp==tp or ep==PLAYER_ALL) and cv>=Duel.GetLP(tp)) then return end
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTargetRange(1,0)
	  e1:SetValue(0)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)	
	  Duel.Destroy(re:GetHandler(),REASON_EFFECT)   end
end

function c598.atkop(e,tp,eg,ep,ev,re,r,rp)
			e:GetHandler():RegisterFlagEffect(592,RESET_EVENT+0x1fe0000,0,1)
end
