local s,id=GetID()
--利益均分的伪契约书 (KDIY)
function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --Set and active
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)

	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end

function s.filter2(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
	    and c:IsType(TYPE_CONTINUOUS)
		and (not condition or condition(te,1-tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,1-tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,1-tp,eg,ep,ev,re,r,rp,0))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(s.filter2,1-tp,LOCATION_DECK,0,2,nil,tp,eg,ep,ev,re,r,rp) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter2,1-tp,LOCATION_DECK,0,nil,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 or #sg<2 then return end
	local g=sg:Select(1-tp,2,2,nil)
	if #g ~= 2 then return end
	for tc in aux.Next(g) do
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		if te then
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			Duel.ClearTargetCard()
			-- e:SetCategory(te:GetCategory())
			-- e:SetProperty(te:GetProperty())
			local loc=LOCATION_SZONE
			-- if (tpe&TYPE_FIELD)~=0 then
			-- 	loc=LOCATION_FZONE
			-- 	local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			-- 	if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			-- end
			Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			tc:CreateEffectRelation(te)
			if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if co then co(te,1-tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,1-tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and #g==1 then
				tc:SetCardTarget(g:GetFirst())
				tc:CreateRelation(g:GetFirst(),RESET_EVENT+RESETS_STANDARD)
			end
			if op then op(te,1-tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if etc then
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT, true)
	Duel.Damage(tp,1000,REASON_EFFECT, true)
	Duel.RDComplete()
end