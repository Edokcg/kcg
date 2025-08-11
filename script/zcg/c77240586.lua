--殉道者的平等待遇(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(s.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e12:SetTarget(s.distg9)
	c:RegisterEffect(e12)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil) 
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil) 
	if #g>#g2 then
		local ct=#g-#g2
		local hg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.SendtoGrave(hg,REASON_DISCARD+REASON_EFFECT)
	elseif  #g<#g2  and Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_DRAW then
		local ct=#g2-#g 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(ct)
		Duel.RegisterEffect(e1,1-tp)
	end
end
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end 