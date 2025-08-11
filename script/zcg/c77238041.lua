--碎魂者 百星(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.tg)
	c:RegisterEffect(e3)

	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	 --summon
	local e91=Effect.CreateEffect(c)
	e91:SetType(EFFECT_TYPE_SINGLE)
	e91:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e91:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e91)
	local e92=Effect.CreateEffect(c)
	e92:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e92:SetCode(EVENT_SUMMON_SUCCESS)
	e92:SetTarget(s.tg92)
	e92:SetOperation(s.op92)
	c:RegisterEffect(e92)
	local e93=Effect.CreateEffect(c)
	e93:SetType(EFFECT_TYPE_FIELD)
	e93:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e93:SetCode(EFFECT_FORBIDDEN)
	e93:SetRange(LOCATION_MZONE)
	e93:SetTargetRange(0,0xff)
	e93:SetTarget(s.bantg93)
	c:RegisterEffect(e93)
	local e94=Effect.CreateEffect(c)
	e94:SetType(EFFECT_TYPE_SINGLE)
	e94:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e94:SetRange(LOCATION_MZONE)
	e94:SetCode(EFFECT_IMMUNE_EFFECT)
	e94:SetValue(s.efilter94)
	c:RegisterEffect(e94)
end
function s.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0xa160)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	local coin=Duel.TossCoin(tp,1)
	if coin==0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.efilter94(e,te)
	return te:GetHandler():IsSetCard(0xa70)
end
function s.bantg93(e,c)
	return c:IsSetCard(0xa70) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function s.filter(c)
	return c:IsSetCard(0xa70)
end
function s.tg92(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end

function s.op92(e, tp, eg, ep, ev, re, r, rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end






