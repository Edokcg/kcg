--奥利哈刚 铁石大将(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con1)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(s.con2)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end

function s.efilter(e, te)
	return te:IsActiveType(TYPE_SPELL + TYPE_TRAP) and te:GetOwnerPlayer() ~= e:GetHandlerPlayer()
end

function s.con1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetFlagEffect(id) == 0
end
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
function s.target(e,c)
	return c:IsSetCard(0xa50)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa50)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,3,nil)
end