--反-希望 絶望神 (K)
function c356.initial_effect(c)
	Xyz.AddProcedure(c,nil,12,5)
	c:EnableReviveLimit()

	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_FIELD)
	  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	  e1:SetRange(LOCATION_MZONE)
	  e1:SetTargetRange(0,1)
	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e1:SetTarget(c356.splimit)
	  c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56840427,0))
	  e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(0)	   
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c356.atkcon)
	e2:SetCost(c356.atkcost)
	e2:SetTarget(c356.atktg)
	e2:SetOperation(c356.atkop)
	--c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5975022,0))
	e3:SetProperty(0)	 
	  e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c356.atkcon2)
	e3:SetCost(c356.atkcost2)
	e3:SetTarget(c356.atktg2)
	e3:SetOperation(c356.atkop2)
	--c:RegisterEffect(e3)

	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(68396121,0))
	  e5:SetProperty(0+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	  e5:SetType(EFFECT_TYPE_QUICK_O)
	  e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1)
	e5:SetCondition(c356.negcon)
	e5:SetCost(c356.negcost)
	e5:SetTarget(c356.negtg)
	e5:SetOperation(c356.negop)
	--c:RegisterEffect(e5)

	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_INITIAL)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_BATTLED)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c356.con)
	e9:SetOperation(c356.op)
	c:RegisterEffect(e9)
end

function c356.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
--and not c:IsCode(364)
end

function c356.atkfilter(c)
	return c:IsCode(352) and c:IsAbleToGraveAsCost()
end
function c356.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsOnField() and at:IsFaceup() 
	  and e:GetHandler():GetOverlayGroup():FilterCount(c356.atkfilter,nil)>0
end
function c356.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  local g=e:GetHandler():GetOverlayGroup():Filter(c356.atkfilter,nil)
	if chk==0 then return g:GetCount()>0 end
	  local tc=g:FilterSelect(tp,Card.IsCode,1,1,nil,352)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c356.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c356.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsFaceup() and at:IsFaceup() then
		Duel.AdjustInstantly(a)
		local atk=a:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e1)
		  --cannot destroyed
			local e0=Effect.CreateEffect(c)
		  e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		  e0:SetValue(1)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  at:RegisterEffect(e0)
	end
end

function c356.atkfilter2(c)
	return c:IsCode(353) and c:IsAbleToGraveAsCost()
end
function c356.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(1-tp) and a:IsOnField() and a:IsFaceup() 
	  and e:GetHandler():GetOverlayGroup():FilterCount(c356.atkfilter2,nil)>0
end
function c356.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	  local g=e:GetHandler():GetOverlayGroup():Filter(c356.atkfilter2,nil)
	if chk==0 then return g:GetCount()>0 end
	  local tc=g:FilterSelect(tp,Card.IsCode,1,1,nil,353)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c356.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c356.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	  if a and a:IsFaceup() then
	  Duel.Destroy(a,REASON_EFFECT) end
end

function c356.atkfilter3(c)
	return c:IsCode(355) and c:IsAbleToGraveAsCost()
end
function c356.negcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	local b=Duel.GetMatchingGroupCount(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	return a==b
	  and e:GetHandler():GetOverlayGroup():FilterCount(c356.atkfilter3,nil)>0
end
function c356.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  local g=e:GetHandler():GetOverlayGroup():Filter(c356.atkfilter3,nil)
	if chk==0 then return g:GetCount()>0 end
	  local tc=g:FilterSelect(tp,Card.IsCode,1,1,nil,355)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c356.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c356.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c356.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c356.filter,tp,0,LOCATION_ONFIELD,nil)
	  local tc=g:GetFirst()
	while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	  tc=g:GetNext()
	  end
end

function c356.con(e)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local bc=c:GetBattleTarget()
	if not bc then return end
	local bct=0
	if bc:GetPosition()==POS_FACEUP_ATTACK then
		bct=bc:GetAttack()
	else bct=bc:GetDefense()+1 end
	return c:IsRelateToBattle() and c:GetPosition()==POS_FACEUP_ATTACK 
	 and atk>=bct and not bc:IsStatus(STATUS_BATTLE_DESTROYED)
end 
function c356.op(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	Duel.Destroy(bc,REASON_RULE)
	bc:SetStatus(STATUS_BATTLE_DESTROYED,true)
end
