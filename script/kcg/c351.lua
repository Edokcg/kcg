--決闘竜の飛翔 (K)
local s,id=GetID()
local zexal=nil
function s.initial_effect(c)
	zexal=c
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.con)
		ge1:SetOperation(s.op)
		Duel.RegisterEffect(ge1,0)
	end)
end

function s.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,e:GetHandler())
	return g:GetCount()>0 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g<1 then return end
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,e:GetHandler())
    if g:GetCount()==0 then return end
    Duel.SendtoHand(g,tp,REASON_EFFECT)
    local g2=Duel.GetOperatedGroup()
	if g2:GetCount()==0 then return end
    local tc=g2:GetFirst()
    while tc do
    Duel.SSet(tp,tc)
    tc=g2:GetNext() end   
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetOwner():GetControler(),EFFECT_CANNOT_SSET)
	and e:GetOwner():IsFaceup() and e:GetOwner():IsStatus(STATUS_CHAINING)
end
function s.splimit(e,c,tp)
	return (not target or target(e,c,tp)) and c~=zexal
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local effs={Duel.GetPlayerEffect(e:GetOwner():GetControler(),EFFECT_CANNOT_SSET)}
	for _,eff in ipairs(effs) do
		if eff:GetLabel()~=351 then
			target=eff:GetTarget()
			eff:SetTarget(s.splimit)
			eff:SetLabel(351)
		end
	end
end