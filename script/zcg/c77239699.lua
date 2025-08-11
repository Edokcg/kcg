--幸运的丽酱
function c77239699.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetCondition(c77239699.tgcon)	
	e1:SetValue(c77239699.valcon)
	c:RegisterEffect(e1)
	
	--[[Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetDescription(aux.Stringid(73734821,0)) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetCost(c77239699.cost)  
	e2:SetCondition(c77239699.condition)
	e2:SetOperation(c77239699.activate)
	c:RegisterEffect(e2)]]
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239699,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c77239699.condition)
	e2:SetCost(c77239699.cost)
	e2:SetTarget(c77239699.target)
	e2:SetOperation(c77239699.activate)
	c:RegisterEffect(e2)
end
-----------------------------------------------------------------------
function c77239699.tgcon(e)
	return e:GetHandler():IsDefensePos()
end
function c77239699.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------------
function c77239699.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--[[function c77239699.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY)
end
function c77239699.activate(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetOperation(c77239699.thop)
		e1:SetReset(RESET_EVENT+0x17a0000)
		re:GetHandler():RegisterEffect(e1)
	end
end
function c77239699.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
	end
end]]
function c77239699.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==tp
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c77239699.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function c77239699.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e1:SetCondition(c77239699.thcon)
        e1:SetOperation(c77239699.thop)
        e1:SetLabelObject(tc)
        Duel.RegisterEffect(e1,tp)
end
function c77239699.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239699.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,tp,REASON_EFFECT)
end