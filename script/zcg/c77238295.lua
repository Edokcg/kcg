--千年眼
function c77238295.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetOperation(c77238295.activate)
    c:RegisterEffect(e2)
	
    --remain field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e3)
end
function c77238295.activate(e,tp,eg,ep,ev,re,r,rp)
    local opt=0
	opt=Duel.SelectOption(1-tp,aux.Stringid(77238295,0),aux.Stringid(77238295,1))
    if opt==0 then
		--must attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	else
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end