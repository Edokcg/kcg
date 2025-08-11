--黑暗的奇襲 (K)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.atcon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)	
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_END
end
function s.atktarget(c,e,tp)
	return (c:GetTurnID()==Duel.GetTurnCount() 
	and (c:IsSummonType(SUMMON_TYPE_SPECIAL) or c:IsSummonType(SUMMON_TYPE_NORMAL)))
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.atktarget,tp,LOCATION_GRAVE,0,nil,e,tp)
		return g:GetCount()>0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if Duel.GetTurnPlayer()==tp then
		local g=Duel.GetMatchingGroup(s.atktarget,tp,LOCATION_GRAVE,0,nil,e,tp)
		local p=tp
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_END,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,p==tp and 2 or 1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,p==tp and 2 or 1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,p==tp and 2 or 1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_EP)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1,Duel.GetCurrentPhase()<=PHASE_MAIN1 and 2 or 1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_EP)
		e3:SetTargetRange(0,1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)

		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct<1 then return end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if #g2>ct then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g2=g:Select(tp,ct,ct,nil)
		end
		if #g2<1 then return end
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		-- local e1=Effect.CreateEffect(e:GetHandler())
		-- e1:SetType(EFFECT_TYPE_FIELD)
		-- e1:SetCode(EFFECT_BP_TWICE)
		-- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		-- e1:SetTargetRange(1,0)
		-- e1:SetReset(RESET_PHASE+PHASE_END)
		-- Duel.RegisterEffect(e1,tp)
	
	-- local e5=Effect.CreateEffect(e:GetHandler())
	-- e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	-- e5:SetCountLimit(1)
	-- e5:SetOperation(s.atop32)
	-- e5:SetReset(RESET_PHASE+PHASE_END)
	-- Duel.RegisterEffect(e5,tp) 
	end
end
-- function s.atop32(e,tp,eg,ep,ev,re,r,rp)
-- 	--cannot attack
-- 	local e8=Effect.CreateEffect(e:GetHandler())
-- 	e8:SetType(EFFECT_TYPE_FIELD)
-- 	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
-- 	e8:SetTargetRange(LOCATION_MZONE,0)
-- 	e8:SetTarget(s.atktarget)
-- 	e8:SetReset(RESET_PHASE+PHASE_END)
-- 	Duel.RegisterEffect(e8,tp) 
-- end

