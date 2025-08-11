--多日鼠(neet)
local s,id=GetID()
function s.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_CHAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_GRAVE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local ct=0
	if tc:IsType(TYPE_MONSTER) then ct=ct+TYPE_MONSTER end
	if tc:IsType(TYPE_SPELL) then ct=ct+TYPE_SPELL end
	if tc:IsType(TYPE_TRAP) then ct=ct+TYPE_TRAP end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.drop)
	e1:SetLabel(ct)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1,{id,1})
	e0:SetOperation(s.damop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(e0)
	Duel.RegisterEffect(e0,tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(e:GetLabel()) and rp==1-tp
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_CARD,0,id)
	if Duel.Draw(tp,1,REASON_EFFECT)==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,id)
	if ct==0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Recover(tp,1000,REASON_EFFECT)
	elseif ct>2 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SetLP(tp,Duel.GetLP(tp)-3000)  
	end
end