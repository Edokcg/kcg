--前
function c77239078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)	
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_DRAW)	
    e1:SetCondition(c77239078.condition)	
	e1:SetOperation(c77239078.activate)
	c:RegisterEffect(e1)
end
function c77239078.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c77239078.activate(e,tp,eg,ep,ev,re,r,rp)
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetCode(EFFECT_SKIP_DP)
    e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
    Duel.RegisterEffect(e4,tp)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_SKIP_SP)
    Duel.RegisterEffect(e5,tp)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_SKIP_M1)
    Duel.RegisterEffect(e6,tp)	
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_EP)
    Duel.RegisterEffect(e7,tp)	
    local e8=e7:Clone()
    e8:SetCode(EFFECT_CANNOT_BP)
    Duel.RegisterEffect(e8,tp)
	
	local lp=Duel.GetLP(tp)
	local lp1=Duel.GetLP(1-tp)	
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_DRAW and lp<lp1 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.BreakEffect()
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_SET_ATTACK)
            e2:SetValue(tc:GetBaseAttack()*2)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e2)
		end	
	end   
end

