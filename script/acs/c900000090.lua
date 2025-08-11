--千年积木
function c900000090.initial_effect(c)
	
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--自己与对方的基本分值互换
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c900000090.cost)
	e2:SetOperation(c900000090.activate)
	c:RegisterEffect(e2)
	
	--我方怪兽召唤回合不能攻击
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c900000090.stg)
	c:RegisterEffect(e3)
	
	--效果不会被无效化
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e4)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1
		and e:GetHandler():IsReleasable() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c900000090.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	Duel.SetLP(tp,lp2)
	Duel.SetLP(1-tp,lp1)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000090.stg(e,c)
	return c:IsStatus(STATUS_SUMMON_TURN)
end
