--黑魔導女孩 樱子(ZCG)
function c77239983.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239983.spcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77239983.efilter)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--3000 lp
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(c77239983.lptg)
	e4:SetOperation(c77239983.lpop)
	c:RegisterEffect(e4)
end
function c77239983.filter(c)
	return c:IsFaceup() and c:IsCode(77239982)
end
function c77239983.filter1(c)
	return c:IsCode(77239982)
end
function c77239983.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c77239983.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c77239983.filter1,c:GetControler(),LOCATION_HAND,0,1,nil))
end
function c77239983.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c77239983.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(1-tp)>3000 end
	Duel.SetTargetPlayer(1-tp)
end
function c77239983.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,3000)
end
