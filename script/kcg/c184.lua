--シューティング・ライザー・ドラゴ
--Shooting Riser Dragon
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)

	--synchro effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50091196,1))
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_UNCOPYABLE)  
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)  
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(s.sccon)
	e5:SetTarget(s.sctarg)
	e5:SetOperation(s.scop)
	c:RegisterEffect(e5)
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgfilter(c,lv)
	return c:IsLevelBelow(lv-1) and c:IsAbleToGrave()
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,c:GetLevel())
	if #g==0 or Duel.SendtoGrave(g,REASON_EFFECT)~=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=g:GetFirst():GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
end
function s.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSynchroSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	--if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	  --local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c) 
	--local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c) 
	--if g:GetCount()>0 then 
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
		Duel.SynchroSummon(tp,c,nil)
		--local sg=g:Select(tp,1,1,nil) 
		--Duel.SynchroSummon(tp,sg:GetFirst(),c) 
	end 
end