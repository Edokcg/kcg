--死亡面具
function c77239027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77239027.condition)	
	e1:SetTarget(c77239027.target)
	e1:SetOperation(c77239027.activate)
	c:RegisterEffect(e1)
end
function c77239027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c77239027.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e2:SetCountLimit(1)
        e2:SetOperation(c77239027.atkop)
		tc:RegisterEffect(e2)		
	end
end
function c77239027.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(300)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	    e2:SetValue(300)
	    c:RegisterEffect(e2)		
    end
end