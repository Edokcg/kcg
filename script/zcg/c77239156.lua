--魔力的封印(ZCG)
function c77239156.initial_effect(c)
    --[[Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_STANDBY_PHASE,0x1c0)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77239156.target)
    e1:SetOperation(c77239156.operation)
    c:RegisterEffect(e1)]]
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c77239156.target)
	e1:SetOperation(c77239156.operation)
	c:RegisterEffect(e1)
end

--[[function c77239156.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end]]
function c77239156.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        c:SetCardTarget(tc)
        c:CreateRelation(tc,RESET_EVENT+0x1fe0000)
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c77239156.rcon)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e5)
    end
end
--[[function c77239156.efftg(e,c)
    return e:GetHandler():IsRelateToCard(c)
end]]

function c77239156.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239156.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end