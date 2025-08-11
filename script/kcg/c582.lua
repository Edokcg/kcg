--源數覆寫效果 (KA)
function c582.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(799183,0))
	  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c582.condition)
	e1:SetTarget(c582.target)
	e1:SetOperation(c582.activate)
	c:RegisterEffect(e1)
end

function c582.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return (ex or ex2) 
	and re:GetHandler():IsControler(1-tp) and Duel.IsChainNegatable(ev)
end
function c582.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c582.filter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))
		and (not condition or condition(te,1-tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,1-tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,1-tp,eg,ep,ev,re,r,rp,0))
end
function c582.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) 
end
function c582.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
	if Duel.Destroy(eg,REASON_EFFECT)==1 then
	local g=Duel.GetOperatedGroup():GetFirst()

	if g:IsType(TYPE_MONSTER) then
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c582.filter2,tp,0,LOCATION_DECK,1,nil,e,tp) then 
	local g=Duel.GetMatchingGroup(c582.filter2,tp,0,LOCATION_DECK,nil,e,tp)
	Duel.ConfirmCards(tp,g) 
	local g2=g:Select(tp,1,1,nil)
	Duel.ShuffleDeck(1-tp)
	local tc=g2:GetFirst()
	if tc then 
		Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		--cannot trigger
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
		Duel.ShuffleDeck(1-tp) end
	end end 

	if g:IsType(TYPE_SPELL+TYPE_TRAP) then
	if Duel.IsExistingMatchingCard(c582.filter,tp,0,LOCATION_DECK,1,nil,tp,eg,ep,ev,re,r,rp) then  
	local g=Duel.GetMatchingGroup(c582.filter,tp,0,LOCATION_DECK,nil,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp,g) 
	local g2=g:Select(tp,1,1,nil)
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
		if tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and gg and #gg==1 then 
			tc:SetCardTarget(gg:GetFirst())
			tc:CreateRelation(gg:GetFirst(),RESET_EVENT+RESETS_STANDARD)
		end
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
	end end end end
end