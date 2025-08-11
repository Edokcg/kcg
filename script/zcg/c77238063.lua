--碎魂者之幻术拖延(ZCG)
local s,id=GetID()
function s.initial_effect(c)
 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
		--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e22:SetCode(EFFECT_CANNOT_ACTIVATE)
	e22:SetRange(LOCATION_SZONE)
	e22:SetTargetRange(0,1)
	e22:SetValue(aux.TRUE)
	c:RegisterEffect(e22)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e93=Effect.CreateEffect(c)
	e93:SetType(EFFECT_TYPE_FIELD)
	e93:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e93:SetCode(EFFECT_FORBIDDEN)
	e93:SetRange(LOCATION_SZONE)
	e93:SetTargetRange(0,0xff)
	e93:SetTarget(s.bantg93)
	c:RegisterEffect(e93)
	local e94=Effect.CreateEffect(c)
	e94:SetType(EFFECT_TYPE_SINGLE)
	e94:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e94:SetRange(LOCATION_SZONE)
	e94:SetCode(EFFECT_IMMUNE_EFFECT)
	e94:SetValue(s.efilter94)
	c:RegisterEffect(e94)
	--
	local e95 = Effect.CreateEffect(c)
	e95:SetType(EFFECT_TYPE_FIELD)
	e95:SetCode(EFFECT_DISABLE)
	e95:SetRange(LOCATION_SZONE)
	e95:SetTargetRange(0, LOCATION_ONFIELD)
	e95:SetTarget(s.distg95)
	c:RegisterEffect(e95)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_ADJUST)
	e103:SetRange(LOCATION_SZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	c:RegisterEffect(e1)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
	end
end

function s.efilter94(e,te)
	return te:GetHandler():IsSetCard(0xa70)
end
function s.bantg93(e,c)
	return c:IsSetCard(0xa70) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function s.distg95(e, c)
	return c:IsSetCard(0xa70)
end
function s.filter96(c)
	return c:IsSetCard(0xa70)
end
function s.filter99(c)
	return c:IsSetCard(0xa70) and c:IsFaceup()
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter99,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	end
end







