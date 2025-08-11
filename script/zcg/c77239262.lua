--奥利哈刚之气(ZCG)
function c77239262.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77239262.con)
	e1:SetTarget(c77239262.target1) 
	e1:SetOperation(c77239262.activate1)	
	c:RegisterEffect(e1)
	
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239262,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c77239262.condition)
	e2:SetCost(c77239262.cost)
	e2:SetTarget(c77239262.target)
	e2:SetOperation(c77239262.activate)
	c:RegisterEffect(e2)
	
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)   
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239262.recon)	
	e3:SetTarget(c77239262.target2)
	e3:SetOperation(c77239262.operation)
	c:RegisterEffect(e3)
end
---------------------------------------------------------------------------------
function c77239262.filter(c)
	return c:GetOriginalCodeRule()==48179391
end
function c77239262.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end 
end
function c77239262.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239262.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Overlay(e:GetHandler(),tc) 
	end
	e:GetHandler():CopyEffect(77239261,1) 
end
function c77239262.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(48179391,tp)
end
---------------------------------------------------------------------------------
function c77239262.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function c77239262.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c77239262.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239262.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77239262.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c77239262.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c77239262.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	Duel.Destroy(eg,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239262.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239262.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c77239262.operation(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
