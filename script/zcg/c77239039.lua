--预警机械虫
function c77239039.initial_effect(c)
	--抽牌确认
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77239039.condition)	
    e1:SetOperation(c77239039.operation)
	c:RegisterEffect(e1)	
end
function c77239039.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77239039.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(tp,tc)
        Duel.BreakEffect()		
        if tc:IsType(TYPE_SPELL) then
	        Duel.Damage(1-tp,500,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end