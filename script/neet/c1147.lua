--カウンター・カウンター
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and (Duel.IsChainNegatable(ev) or (re:GetHandler():CheckActivateEffect(false,true,false)~=nil and not re:GetHandler():IsCode(id)))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=re:GetHandler():IsType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	local b2=re:GetHandler():CheckActivateEffect(false,true,false)~=nil and not re:GetHandler():IsCode(id)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	else
		local te,ceg,cep,cev,cre,cr,crp=re:GetHandler():CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	else
		local te=e:GetLabelObject()
		if not te then return end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
