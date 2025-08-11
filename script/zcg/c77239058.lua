--冥界守护者 忒拉蒙(ZCG)
function c77239058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239058,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c77239058.cost)
	e1:SetOperation(c77239058.operation)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239058,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77239058.reccon)
	e2:SetTarget(c77239058.rectg)
	e2:SetOperation(c77239058.recop)
	c:RegisterEffect(e2)
	if c77239058.counter==nil then
		c77239058.counter=true
		c77239058[0]=0
		c77239058[1]=0
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c77239058.resetcount)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge3:SetCode(EVENT_DAMAGE)
		ge3:SetOperation(c77239058.addcount)
		Duel.RegisterEffect(ge3,0)
	end
end
function c77239058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239058.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c77239058.refcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77239058.refcon(e,re,val,r,rp,rc)
	return rp==1-e:GetHandlerPlayer()
end
function c77239058.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c77239058[0]=0
	c77239058[1]=0
end
function c77239058.addcount(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	local d=math.floor(ev)
	if d>=1 then c77239058[tp]=c77239058[tp]+d	
	else c77239058[tp]=c77239058[tp] end  
end
function c77239058.reccon(e,tp,eg,ep,ev,re,r,rp)
	return c77239058[tp]>0 
end
function c77239058.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c77239058[tp]/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,c77239058[tp]/2)
end
function c77239058.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
