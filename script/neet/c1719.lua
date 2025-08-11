--I：P路由助手（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Link summon procedure
	Link.AddProcedure(c,s.matfilter,2,2)
	--Link summon 1 link monster during opponent's main phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.effcon)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)   
end
function s.matfilter(c,lc,st,tp)
	return not c:IsType(TYPE_LINK,lc,st,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsMainPhase()
end
function s.filter(tc,c,g,tp)
	local mg=g:AddCard(c)
	return tc:IsFaceup() and tc:IsCanBeLinkMaterial() and g:IsContains(tc)
		and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg,#mg,#mg)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local c=e:GetHandler()
		local g=c:GetLinkedGroup():Filter(Card.IsControler,nil,1-tp)
		return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,c,g,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup():Filter(Card.IsControler,nil,1-tp)
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,c,g,tp) then
		local mg=g:AddCard(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,mg,#mg,#mg)
		local sc=sg:GetFirst()
		if sc then
			Duel.LinkSummon(tp,sc,nil,mg,#mg,#mg)
		end
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>=1 then return end
	local ct=1
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then 
		ct=2
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,0,ct)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e2,tp)
end