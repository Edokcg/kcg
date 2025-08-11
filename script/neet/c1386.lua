--终末之焰(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory((CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2,{id,0})	
	e1:SetCondition(function(e,tp) return Duel.IsMainPhase() and Duel.GetTurnPlayer()==tp end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={46173680}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46173680,0,TYPES_TOKEN,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,46173680,0,TYPES_TOKEN,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then return end
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,46173680)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	--Cannot be Tributed for a Tribute Summon of a non-DARK monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(function(_,c) return c:IsAttributeExcept(ATTRIBUTE_DARK) end)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	token:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()

	if Duel.GetFlagEffect(tp,id+1)<1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE|PHASE_END,0,1)
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(s.splpcon)
		e1:SetOperation(s.splpop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_DELAY)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(s.lpcon)
		e4:SetOperation(s.lpop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)

		--sp_summon effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(s.regcon)
		e2:SetOperation(s.regop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(s.drcon2)
		e3:SetOperation(s.drop2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.filter(c,sp)
	return c:GetSummonPlayer()==sp and not c:IsAttribute(ATTRIBUTE_DARK)
end
function s.splpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.splpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-800)
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-800)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,id)
	Duel.ResetFlagEffect(tp,id)
	Duel.SetLP(tp,Duel.GetLP(tp)-800*n)
end