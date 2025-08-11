--巨石遗物·阿巴太尔(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot be special summoned
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.ritlimit)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_SPSUMMON_COST)  
	e2:SetCost(s.cost)  
	c:RegisterEffect(e2) 
	--Ritual Summon
	local e3=Ritual.CreateProc(c,RITPROC_GREATER,aux.FilterBoolFunction(Card.IsSetCard,0x138),nil,aux.Stringid(25726386,0),nil,nil,nil,nil,nil,function(e,tp,g,sc) return not g:IsContains(e:GetHandler()), g:IsContains(e:GetHandler()) end)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCondition(function() return Duel.IsMainPhase() end)
	e3:SetCost(s.rcost)
	c:RegisterEffect(e3)
	--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end
s.listed_series={0x138}
function s.mat_filter(c,tp)
	return c:IsSetCard(0x138)
end
function s.ritual_custom_check(e,tp,g,c)
	return #g>=3 
end
function s.ritlimit(e,se,sp,st)
	if (st&SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
		return e:GetHandler():IsLocation(LOCATION_HAND) 
	end
	return true
end
function s.cost(e,c,tp,st)  
	if (st&SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL then return true end
	return Duel.GetTurnPlayer()==tp
end  
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)//2)
		local turn_player=Duel.GetTurnPlayer()
		Duel.SkipPhase(turn_player,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turn_player,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turn_player,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(turn_player,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
		Duel.SkipPhase(turn_player,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turn_player)	  
	end 
end