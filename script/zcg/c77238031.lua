--不死之究极昆虫 LV7(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate) 
	c:RegisterEffect(e1) 
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.con1)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end
s.lvdn={77240679,77240680,77240681}
function s.con2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ex1, tg1, tc1 = Duel.GetOperationInfo(ev, CATEGORY_DESTROY)
	local ex2, tg2, tc2 = Duel.GetOperationInfo(ev, CATEGORY_CONTROL)
	local ex3, tg3, tc3 = Duel.GetOperationInfo(ev, CATEGORY_COUNTER)
	local ex4, tg4, tc4 = Duel.GetOperationInfo(ev, CATEGORY_POSITION)
	local ex5, tg5, tc5 = Duel.GetOperationInfo(ev, CATEGORY_RELEASE)
	local ex6, tg6, tc6 = Duel.GetOperationInfo(ev, CATEGORY_REMOVE)
	local ex7, tg7, tc7 = Duel.GetOperationInfo(ev, CATEGORY_TOHAND)
	local ex8, tg8, tc8 = Duel.GetOperationInfo(ev, CATEGORY_TODECK)
	local ex9, tg9, tc9 = Duel.GetOperationInfo(ev, CATEGORY_TOGRAVE)
	return (ex1 and tg1 ~= nil and tg1:IsContains(c)) or (ex2 and tg2 ~= nil and tg2:IsContains(c)) or
			   (ex3 and tg3 ~= nil and tg3:IsContains(c)) or (ex4 and tg4 ~= nil and tg4:IsContains(c)) or
			   (ex5 and tg5 ~= nil and tg5:IsContains(c)) or (ex6 and tg6 ~= nil and tg6:IsContains(c)) or
			   (ex7 and tg7 ~= nil and tg7:IsContains(c)) or (ex8 and tg8 ~= nil and tg8:IsContains(c)) or
			   (ex9 and tg9 ~= nil and tg9:IsContains(c))
end
function s.op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:GetFlagEffect(id) == 0 then
		c:RegisterFlagEffect(id, RESET_PHASE + PHASE_END, 0, 1)
	end
end
function s.efilter(e, te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end

function s.con1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetFlagEffect(id) == 0
end
function s.con(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_LV
end
function s.filter(c)
	return c:GetAttack()>0 and c:GetFlagEffect(id)<=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	local tc=sg:GetFirst()
	local dg=Group.CreateGroup()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+0x1ec0000,0,1)
		if tc:GetAttack()<=1000 then
			dg:AddCard(tc)
		end
		tc=sg:GetNext()
	end
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end


