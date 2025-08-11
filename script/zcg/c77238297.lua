--千年钥匙(ZCG)
function c77238297.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)

    --return
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
	e3:SetCondition(c77238297.condition)
    e3:SetOperation(c77238297.activate)
    c:RegisterEffect(e3)
end

function c77238297.filter1(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_HAND)
end

function c77238297.filter2(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_DECK)
end

function c77238297.filter3(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c77238297.filter4(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_GRAVE)
end

function c77238297.filter5(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_REMOVED)
end

function c77238297.filter6(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==(Duel.GetTurnCount()-1)) and c:IsPreviousLocation(LOCATION_EXTRA)
end

function c77238297.filter7(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (c:GetTurnID()==Duel.GetTurnCount()) and c:IsPreviousLocation(LOCATION_DECK)
end

function c77238297.condition(c)
	return Duel.GetTurnCount()>=2
end

function c77238297.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(c77238297.filter1,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
    if #sg1>0 then
	Duel.SendtoHand(sg1,nil,REASON_RULE)
    end
    local sg2=Duel.GetMatchingGroup(c77238297.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
    if #sg2>0 then
		local tc=sg2:GetFirst()
		while tc do
			local og=tc:GetOverlayGroup()
			local tc1=og:GetFirst()
			while tc1 do
				if tc1:IsType(TYPE_MONSTER) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
					tc1=og:GetNext()
				elseif tc1:IsType(TYPE_MONSTER) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_MONSTER) and tc:IsPreviousControler(tp) and tc1:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc1,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_MONSTER) and tc:IsPreviousControler(tp) and tc1:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc1,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc1,1-tp,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc1,1-tp,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc1,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(1-tp) and tc1:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc1,POS_FACEUP,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(tp) and tc1:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc1,tp,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(tp) and tc1:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc1,tp,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(tp) and tc1:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(tp) and tc1:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc1,REASON_RULE)
				tc1=og:GetNext()
				elseif tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousControler(tp) and tc1:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc1,POS_FACEUP,REASON_RULE)
				tc1=og:GetNext()
				end
			end
			tc=sg2:GetNext()
		end
	Duel.SendtoDeck(sg2,nil,0,REASON_RULE)
    end
    local sg3=Duel.GetMatchingGroup(c77238297.filter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,e:GetHandler())
    if #sg3>0 then
    local tc2=sg3:GetFirst()
    while tc2 do
    if tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEUP_ATTACK) then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
    elseif tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEUP_DEFENSE) then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
    elseif tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEUP_ATTACK) then
    Duel.MoveToField(tc2,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
    elseif tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEUP_DEFENSE) then
    Duel.MoveToField(tc2,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
    elseif tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEDOWN_DEFENSE) then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
    elseif tc2:IsType(TYPE_MONSTER) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEDOWN_DEFENSE) then
    Duel.MoveToField(tc2,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
	elseif tc2:IsType(TYPE_FIELD) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEUP) then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
    elseif tc2:IsType(TYPE_FIELD) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEUP) then
    Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	elseif tc2:IsType(TYPE_FIELD) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEDOWN) then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_FZONE,POS_FACEDOWN,true)
    elseif tc2:IsType(TYPE_FIELD) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEDOWN) then
    Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
    elseif tc2:IsType(TYPE_TRAP) and tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) and tc2:IsPreviousControler(1-tp) and tc2:IsPreviousPosition(POS_FACEUP) then
		local te=tc2:GetActivateEffect()
		local tep=tc2:GetControler()
		local condition
		local cost
		local target
		local operation
		if te then
			condition=te:GetCondition()
			cost=te:GetCost()
			target=te:GetTarget()
			operation=te:GetOperation()
		end
		local chk=te and te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
			and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
            Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		if chk then
			Duel.ClearTargetCard()
			e:SetProperty(te:GetProperty())
			Duel.Hint(HINT_CARD,0,tc2:GetOriginalCode())
			if tc2:GetType()==(TYPE_SPELL+TYPE_TRAP) then
				tc2:CancelToGrave(false)
			end
			tc2:CreateEffectRelation(te)
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if target~=te:GetTarget() then
				target=te:GetTarget()
			end
			if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			for tg in aux.Next(g) do
				tg:CreateEffectRelation(te)
			end
			tc2:SetStatus(STATUS_ACTIVATED,true)
			if tc2:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc2:SetStatus(STATUS_LEAVE_CONFIRMED,false)
			end
			if operation~=te:GetOperation() then
				operation=te:GetOperation()
			end
			if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
			tc2:ReleaseEffectRelation(te)
			for tg in aux.Next(g) do
				tg:ReleaseEffectRelation(te)
			end
		else
			Duel.ChangePosition(tc2,POS_FACEDOWN)
		end
    elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) and (((not tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)) and tc2:IsPreviousPosition(POS_FACEUP)) or (tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) and tc2:IsPreviousPosition(POS_FACEDOWN)) or tc2:IsPreviousPosition(POS_FACEDOWN)) and tc2:IsPreviousControler(1-tp)  then
    Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
	elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) and tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) and tc2:IsPreviousControler(tp) and tc2:IsPreviousPosition(POS_FACEUP) then
		local te=tc2:GetActivateEffect()
		local tep=tc2:GetControler()
		local condition
		local cost
		local target
		local operation
		if te then
			condition=te:GetCondition()
			cost=te:GetCost()
			target=te:GetTarget()
			operation=te:GetOperation()
		end
		local chk=te and te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
			and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
			Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if chk then
			Duel.ClearTargetCard()
			e:SetProperty(te:GetProperty())
			Duel.Hint(HINT_CARD,0,tc2:GetOriginalCode())
			if tc2:GetType()==(TYPE_SPELL+TYPE_TRAP) then
				tc2:CancelToGrave(false)
			end
			tc2:CreateEffectRelation(te)
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if target~=te:GetTarget() then
				target=te:GetTarget()
			end
			if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			for tg in aux.Next(g) do
				tg:CreateEffectRelation(te)
			end
			tc2:SetStatus(STATUS_ACTIVATED,true)
			if tc2:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc2:SetStatus(STATUS_LEAVE_CONFIRMED,false)
			end
			if operation~=te:GetOperation() then
				operation=te:GetOperation()
			end
			if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
			tc2:ReleaseEffectRelation(te)
			for tg in aux.Next(g) do
				tg:ReleaseEffectRelation(te)
			end
	else
		Duel.ChangePosition(tc2,POS_FACEDOWN)
	end
	elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) and (((not tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)) and tc2:IsPreviousPosition(POS_FACEUP)) or (tc2:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) and tc2:IsPreviousPosition(POS_FACEDOWN)) or tc2:IsPreviousPosition(POS_FACEDOWN)) and tc2:IsPreviousControler(tp)  then
	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
    end
    tc2=sg3:GetNext()
    end
end
    local sg4=Duel.GetMatchingGroup(c77238297.filter4,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_EXTRA,e:GetHandler())
    if #sg4>0 then
	local tc3=sg4:GetFirst()
		while tc3 do
			local og=tc3:GetOverlayGroup()
			local tc4=og:GetFirst()
			while tc4 do
				if tc4:IsType(TYPE_MONSTER) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc4,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
					tc4=og:GetNext()
				elseif tc4:IsType(TYPE_MONSTER) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc4,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_MONSTER) and tc3:IsPreviousControler(tp) and tc4:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc4,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_MONSTER) and tc3:IsPreviousControler(tp) and tc4:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc4,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc4,1-tp,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc4,1-tp,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc4,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc4,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(1-tp) and tc4:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc4,POS_FACEUP,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(tp) and tc4:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc4,tp,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(tp) and tc4:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc4,tp,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(tp) and tc4:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc4,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(tp) and tc4:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc4,REASON_RULE)
				tc4=og:GetNext()
				elseif tc4:IsType(TYPE_SPELL+TYPE_TRAP) and tc3:IsPreviousControler(tp) and tc4:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc4,POS_FACEUP,REASON_RULE)
				tc4=og:GetNext()
				end
			end
			tc3=sg4:GetNext()
		end
	Duel.SendtoGrave(sg4,REASON_RULE)
    end
    local sg5=Duel.GetMatchingGroup(c77238297.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,e:GetHandler())
    if #sg5>0 then
		local tc5=sg5:GetFirst()
		while tc5 do
			local og=tc5:GetOverlayGroup()
			local tc6=og:GetFirst()
			while tc6 do
				if tc6:IsType(TYPE_MONSTER) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc6,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
					tc6=og:GetNext()
				elseif tc6:IsType(TYPE_MONSTER) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc6,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_MONSTER) and tc5:IsPreviousControler(tp) and tc6:IsPreviousPosition(POS_FACEUP_ATTACK) then
					Duel.MoveToField(tc6,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_MONSTER) and tc5:IsPreviousControler(tp) and tc6:IsPreviousPosition(POS_FACEUP_DEFENSE) then
					Duel.MoveToField(tc6,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc6,1-tp,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc6,1-tp,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc6,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc6,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(1-tp) and tc6:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc6,POS_FACEUP,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(tp) and tc6:IsPreviousLocation(LOCATION_HAND) then
					Duel.SendtoHand(tc6,tp,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(tp) and tc6:IsPreviousLocation(LOCATION_DECK) then
					Duel.SendtoDeck(tc6,tp,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(tp) and tc6:IsPreviousLocation(LOCATION_ONFIELD) then
					Duel.MoveToField(tc6,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(tp) and tc6:IsPreviousLocation(LOCATION_GRAVE) then
					Duel.SendtoGrave(tc6,REASON_RULE)
				tc6=og:GetNext()
				elseif tc6:IsType(TYPE_SPELL+TYPE_TRAP) and tc5:IsPreviousControler(tp) and tc6:IsPreviousLocation(LOCATION_REMOVED) then
					Duel.Remove(tc6,POS_FACEUP,REASON_RULE)
				tc6=og:GetNext()
				end
			end
			tc5=sg5:GetNext()
		end
	Duel.Remove(sg5,nil,REASON_RULE)
    end
    local sg6=Duel.GetMatchingGroup(c77238297.filter6,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
    if #sg6>0 then
	local tc7=sg6:GetFirst()
	while tc7 do
		local og=tc7:GetOverlayGroup()
		local tc8=og:GetFirst()
		while tc8 do
			if tc8:IsType(TYPE_MONSTER) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousPosition(POS_FACEUP_ATTACK) then
				Duel.MoveToField(tc8,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
				tc8=og:GetNext()
			elseif tc8:IsType(TYPE_MONSTER) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousPosition(POS_FACEUP_DEFENSE) then
				Duel.MoveToField(tc8,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_MONSTER) and tc7:IsPreviousControler(tp) and tc8:IsPreviousPosition(POS_FACEUP_ATTACK) then
				Duel.MoveToField(tc8,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_MONSTER) and tc7:IsPreviousControler(tp) and tc8:IsPreviousPosition(POS_FACEUP_DEFENSE) then
				Duel.MoveToField(tc8,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousLocation(LOCATION_HAND) then
				Duel.SendtoHand(tc8,1-tp,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc8,1-tp,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousLocation(LOCATION_ONFIELD) then
				Duel.MoveToField(tc8,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousLocation(LOCATION_GRAVE) then
				Duel.SendtoGrave(tc8,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(1-tp) and tc8:IsPreviousLocation(LOCATION_REMOVED) then
				Duel.Remove(tc8,POS_FACEUP,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(tp) and tc8:IsPreviousLocation(LOCATION_HAND) then
				Duel.SendtoHand(tc8,tp,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(tp) and tc8:IsPreviousLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc8,tp,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(tp) and tc8:IsPreviousLocation(LOCATION_ONFIELD) then
				Duel.MoveToField(tc8,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(tp) and tc8:IsPreviousLocation(LOCATION_GRAVE) then
				Duel.SendtoGrave(tc8,REASON_RULE)
			tc8=og:GetNext()
			elseif tc8:IsType(TYPE_SPELL+TYPE_TRAP) and tc7:IsPreviousControler(tp) and tc8:IsPreviousLocation(LOCATION_REMOVED) then
				Duel.Remove(tc8,POS_FACEUP,REASON_RULE)
			tc8=og:GetNext()
			end
		end
		tc7=sg6:GetNext()
	end
	Duel.SendtoDeck(sg6,nil,0,REASON_RULE)
end
local sg7=Duel.GetMatchingGroup(c77238297.filter7,tp,LOCATION_HAND,0,e:GetHandler())
    if #sg7>0 then
		Duel.SendtoDeck(sg7,nil,0,REASON_RULE)
    end
return end