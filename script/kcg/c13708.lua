--Numeron Rewriting Magic
function c13708.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(799183,0))
	  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c13708.condition)
	e1:SetTarget(c13708.target)
	e1:SetOperation(c13708.activate)
	c:RegisterEffect(e1)
end
function c13708.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsControler(1-tp) and Duel.IsChainNegatable(ev)
end
function c13708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13708.filter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) 
		and (not condition or condition(te,1-tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,1-tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,1-tp,eg,ep,ev,re,r,rp,0))
end
function c13708.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
	if Duel.Destroy(eg,REASON_EFFECT)>0 then
	if Duel.IsExistingMatchingCard(c13708.filter,tp,0,LOCATION_DECK,1,nil,tp,eg,ep,ev,re,r,rp) then  
	local g=Duel.GetMatchingGroup(c13708.filter,tp,0,LOCATION_DECK,nil,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp,g) 
	local g2=g:Select(tp,1,1,nil)
	Duel.ShuffleDeck(1-tp)
	local tc=g2:GetFirst()
	local tpe=tc:GetType()
	if tc then 
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local condition=te:GetCondition()
		local cost=te:GetCost()
		Duel.ClearTargetCard()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		-- e:SetCategory(te:GetCategory())
		-- e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()

		if bit.band(tpe,TYPE_FIELD)~=0 then
		   local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		   if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		local sfloc=LOCATION_SZONE
		if tc:IsType(TYPE_FIELD) then sfloc=LOCATION_FZONE end
		if not Duel.MoveToField(tc,tp,1-tp,sfloc,POS_FACEUP,true) then return end
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:CreateEffectRelation(te)
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
		local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if gg then
			local etc=gg:GetFirst()
			while etc do
					etc:CreateEffectRelation(te)
				etc=gg:GetNext()
			end
		end
		Duel.BreakEffect()
		if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then 
			 etc=gg:GetFirst()
			 while etc do
				 etc:ReleaseEffectRelation(te)
				 etc=gg:GetNext()
			 end
		end 
		if not (bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD)) then
		Duel.SendtoGrave(tc,REASON_RULE) end
		Duel.ShuffleDeck(1-tp) end
	end end end
end