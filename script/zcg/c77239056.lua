--亚修罗的炼狱
function c77239056.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--不会被效果破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c77239056.efdes)
	c:RegisterEffect(e1)

	--不会被战斗破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa13))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
    --维持代价
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c77239056.mtcon)
    e3:SetOperation(c77239056.mtop)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------
function c77239056.efdes(e,re,te)
	return not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
-----------------------------------------------------------
function c77239056.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239056.mtop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(77239056,0)) then
        Duel.DiscardHand(tp,nil,1,1,REASON_COST+REASON_DISCARD)
    else
        Duel.Destroy(e:GetHandler(),REASON_RULE)
    end
end

