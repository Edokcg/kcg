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
	e5:SetValue(s.repvalue)
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
	local ttp=c:GetControler()
	local g=eg:Filter(s.repfilter,nil,ttp)
	if chk==0 then return g:GetCount()>0 and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) and (Duel.GetLocationCount(ttp,LOCATION_MZONE)>0 or Duel.GetFieldGroupCount(ttp,LOCATION_MZONE,0)>0) end
	if Duel.SelectYesNo(ttp,aux.Stringid(19333131,0)) then
		local bg=g
		if Duel.GetLocationCount(ttp,LOCATION_MZONE)<g:GetCount() and Duel.GetLocationCount(ttp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,ttp,aux.Stringid(19333131,0))
			local ag=Duel.SelectMatchingCard(ttp,nil,ttp,LOCATION_MZONE,0,Duel.GetLocationCount(ttp,LOCATION_MZONE),Duel.GetLocationCount(ttp,LOCATION_MZONE),nil)
			if #ag>0 then bg=ag end
		end
		local zone=0
		local ag=Group.CreateGroup()
		for tc in aux.Next(bg) do
			local seq=tc:GetSequence()
			zone=bit.bor(zone,(0x1<<seq))
			if Duel.GetLocationCount(ttp,LOCATION_MZONE)<1 then
			    ag:AddCard(tc)
			else 
				Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_TOZONE)
				local dis=Duel.SelectDisableField(ttp,1,LOCATION_MZONE,0,zone)
				local s=Duel.MoveSequence(tc,math.log(dis,2))
			end
			c:RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1) 
		end
		g:Sub(bg)
		g:Merge(ag)
		g:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetRange(LOCATION_FZONE)
		e2:SetLabel(zone)
		e2:SetLabelObject(g)
		e2:SetOperation(s.disop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		return true
	else return false end
end
function s.repvalue(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.disop(e,tp)
	-- local c=Duel.GetLocationCount(tp,LOCATION_MZONE)
	-- local dis1=0
	-- if e:GetLabel()>c then 
	--     Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,e:GetLabel()-c,e:GetLabel()-c,nil)
	-- 	if Duel.Destroy(g,REASON_RULE)>0 then
	-- 		c=Duel.GetLocationCount(tp,LOCATION_MZONE)
	-- 		dis1=Duel.SelectDisableField(tp,c,LOCATION_MZONE,0,0)
	-- 		for i=1,c do
	-- 			e:GetHandler():RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1)  
	-- 		end  
	-- 	end  
	-- else 
	-- 	dis1=Duel.SelectDisableField(tp,e:GetLabel(),LOCATION_MZONE,0,0)  
	-- 	for i=1,e:GetLabel() do
	-- 		e:GetHandler():RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1)  
	-- 	end 
	-- end
	-- return dis1
	local g=e:GetLabelObject()
	Duel.Destroy(g,REASON_REPLACE+REASON_RULE)
	g:DeleteGroup()
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
	return e:GetHandler():GetFlagEffect(126)>=5
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
