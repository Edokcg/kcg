--超量的终焉使者
function c77239887.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c77239887.efilter)
	c:RegisterEffect(e1)	
	
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77239887.target)
	e2:SetOperation(c77239887.operation)
	c:RegisterEffect(e2)

	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239887,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c77239887.condition)
	e3:SetCost(c77239887.cost)
	e3:SetTarget(c77239887.target1)
	e3:SetOperation(c77239887.activate1)
	c:RegisterEffect(e3)	

	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c77239887.descon)
	c:RegisterEffect(e4)	
end
---------------------------------------------------------------------
function c77239887.efilter(e,re,rp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77239887.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c77239887.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239887.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and 
	Duel.IsExistingTarget(c77239887.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c77239887.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239887.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
---------------------------------------------------------------------
function c77239887.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239887.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239887.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239887.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
---------------------------------------------------------------------
function c77239887.descon(e)
	return e:GetHandler():GetOverlayCount()==0 and Duel.GetAttackTarget()==e:GetHandler()
end

