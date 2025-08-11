--装甲 疯狂的枪兵 （ZCG）
function c77240280.initial_effect(c)
		--flip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(77240280,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e0:SetTarget(c77240280.target)
	e0:SetOperation(c77240280.operation)
	c:RegisterEffect(e0)
  --cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77240280.discon)
	e1:SetTarget(c77240280.distg)
	e1:SetOperation(c77240280.disop)
	c:RegisterEffect(e1)
--negate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c77240280.negcon)
	e0:SetTarget(c77240280.negtg)
	e0:SetOperation(c77240280.negop)
	c:RegisterEffect(e0)
--negate attack
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_BE_BATTLE_TARGET)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c77240280.condition9)
	e11:SetTarget(c77240280.target9)
	e11:SetOperation(c77240280.operation9)
	c:RegisterEffect(e11)
end
function c77240280.condition9(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP_DEFENSE) and tc:IsSetCard(0xa110)
end
function c77240280.target9(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return a:IsOnField() and a:GetControler(1-tp) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c77240280.operation9(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dam=tc:GetAttack()
	if tc:IsRelateToEffect(e) and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		 Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c77240280.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return rp==1-tp
end
function c77240280.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240280.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function c77240280.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or (re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) or not Duel.IsChainNegatable(ev) then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and ((cp~=PLAYER_ALL and Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_RECOVER)) or
		(cp==PLAYER_ALL and (Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_RECOVER) or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_RECOVER))))
end
function c77240280.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240280.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c77240280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240280.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT) 
end
