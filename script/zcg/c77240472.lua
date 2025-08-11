--原始奥利哈刚之神(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 c:EnableReviveLimit()
		--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCondition(aux.bdocon)
	e9:SetTarget(s.detg)
	e9:SetOperation(s.deop)
	c:RegisterEffect(e9)
	  --redirect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98710510,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
  --immune spell
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(98710510,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.thcon)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.CreateToken(tp,98710511)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and not te:GetOwner():IsCode(98710512)   
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
   if Duel.Destroy(sg,REASON_EFFECT)~=0 then
   local g=Duel.GetOperatedGroup()
   local tc=g:GetFirst()
   local damage=0
   while tc do
   local dam=tc:GetAttack()*2+2000
   damage=damage+dam
   tc=g:GetNext()
   end
   Duel.Damage(1-tp,damage,REASON_EFFECT)
end
end

function s.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local dam=tc:GetAttack()*2+2000
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.deop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
