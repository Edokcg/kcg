--霧の王城
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x101)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.desval)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)

	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111215001,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.descon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end

function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
	and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(s.repfilter,nil,tp)
	if chk==0 then return #g>0 end
	g:KeepAlive()
	e:SetLabelObject(g)
	return Duel.SelectEffectYesNo(tp,e:GetHandler())
end
function s.desval(e,c)
	return c:IsControler(e:GetHandlerPlayer())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone0=0
	for tc in aux.Next(e:GetLabelObject()) do
		local seq=tc:GetSequence()
		zone0=bit.bor(zone0,(0x1<<seq))
		local dis=1<<seq
		local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone0)
		if zone then Duel.MoveSequence(tc,math.log(zone,2)) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetOperation(s.disop)
		e1:SetLabel(dis)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		e:SetLabel(e:GetLabel()+dis)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE,0,1)
	end
end
function s.disop(e,tp)
	return e:GetLabel()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToGraveAsCost() 
	and Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>=5
	and Duel.GetLocationCount(tp,LOCATION_MZONE)==0
end
function s.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
