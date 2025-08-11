--無限牢
function c177.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c177.cost1)
	e1:SetTarget(c177.target1)
	e1:SetOperation(c177.activate1)
	c:RegisterEffect(e1)

	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12385,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetCondition(c177.spcon)
      e2:SetCost(c177.cost3)
	e2:SetTarget(c177.target3)
	e2:SetOperation(c177.activate3)
	c:RegisterEffect(e2)

	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500313101,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c177.cost2)
	e3:SetTarget(c177.target2)
	e3:SetOperation(c177.activate2)
	c:RegisterEffect(e3)
end

function c177.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(178,0)) then
		e:GetHandler():RegisterFlagEffect(177,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	 else e:SetProperty(0)
	 end
end
function c177.filter(c)
	return  c:IsType(TYPE_MONSTER)
end
function c177.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c177.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c177.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c177.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c177.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()~=1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	Duel.RaiseEvent(tc,177,e,0,tp,0,0)
	local sg=e:GetLabelObject()
	tc:RegisterFlagEffect(177,RESET_EVENT+0x1fe0000,0,1)
	end
end

function c177.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c177.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
      local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c177.filter2,tp,LOCATION_SZONE,0,1,c) and c:IsFaceup() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c177.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() 
	and c:GetFlagEffect(177)~=0
end
function c177.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c177.filter2,tp,LOCATION_SZONE,0,1,c) end
	local sg=Duel.GetMatchingGroup(c177.filter2,tp,LOCATION_SZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c177.activate3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c177.filter2,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

function c177.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():GetFlagEffect(177)==0  end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(177,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c177.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c177.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c177.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c177.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c177.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	Duel.RaiseEvent(tc,177,e,0,tp,0,0)
	local sg=e:GetLabelObject()
	tc:RegisterFlagEffect(177,RESET_EVENT+0x1fe0000,0,1)
	end
end
