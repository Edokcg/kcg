
function c165.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c165.actcon)
	e1:SetOperation(c165.skipop)	
	c:RegisterEffect(e1)
end

function c165.adfilter(c)
	return c:IsCode(83965310) and c:IsFaceup()
end
function c165.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c165.adfilter,tp,LOCATION_ONFIELD,0,nil)>0
end
function c165.skipop(e,tp,eg,ep,ev,re,r,rp)
    local sel=Duel.SelectOption(tp,aux.Stringid(13732,9),aux.Stringid(13732,10),aux.Stringid(13732,11),aux.Stringid(13732,12),aux.Stringid(13732,13),aux.Stringid(13732,14))
    if sel==0 then
    local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCode(EFFECT_SKIP_DP)
	if (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()>PHASE_DRAW) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW) then
		e5:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN) end
	if (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_DRAW) or (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_DRAW) then
		e5:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN) end	
	Duel.RegisterEffect(e5,tp) end
    if sel==1 then
    local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetCode(EFFECT_SKIP_SP)
	if (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()>PHASE_STANDBY) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY) then
		e6:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN) end
	if (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_STANDBY) or (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_STANDBY) then
		e6:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN) end	
	Duel.RegisterEffect(e6,tp) end 
    if sel==2 then
    local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	e7:SetCode(EFFECT_SKIP_M1)
	if (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()>PHASE_MAIN1) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_MAIN1) then
		e7:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN) end
	if (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_MAIN1) or (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_MAIN1) then
		e7:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN) end	
	Duel.RegisterEffect(e7,tp) end
    if sel==3 then
    local e8=Effect.CreateEffect(e:GetHandler())
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,1)
	e8:SetCode(EFFECT_SKIP_BP)
	if (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()>PHASE_BATTLE) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<PHASE_BATTLE) then
		e8:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN) end
	if (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_BATTLE) or (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<PHASE_BATTLE) then
		e8:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN) end
	Duel.RegisterEffect(e8,tp) end
    if sel==4 then
    local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetCode(EFFECT_SKIP_M2)
	if (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()>PHASE_MAIN2) or (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_MAIN2) then
		e9:SetReset(RESET_PHASE+PHASE_MAIN2+RESET_OPPO_TURN) end
	if (Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_MAIN2) or (Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_MAIN2) then
		e9:SetReset(RESET_PHASE+PHASE_MAIN2+RESET_SELF_TURN) end	
	Duel.RegisterEffect(e9,tp) end
	if sel==5 then
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_EP)
	if Duel.GetTurnPlayer()==tp then
		e10:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN) end
	if Duel.GetTurnPlayer()==1-tp then
		e10:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) end		
	Duel.RegisterEffect(e10,tp) end
end