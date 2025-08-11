--御用同调士(neet)
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()-e:GetHandler():GetLevel())
end
function s.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	local lv=tc:GetLevel()-c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	-- cannot summon extra deck monsters except synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
	-- lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_SYNCHRO)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and (r&REASON_SYNCHRO)==REASON_SYNCHRO and (c:GetReasonCard():IsAttribute(ATTRIBUTE_EARTH) or c:GetReasonCard():IsRace(RACE_WARRIOR))
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and c:GetReasonCard():IsAttribute(ATTRIBUTE_EARTH)
	local b2=Duel.IsPlayerCanDraw(tp,1) and c:GetReasonCard():IsRace(RACE_WARRIOR)
	if chk==0 then return b1 or b2 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local breakeffect=false
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and c:GetReasonCard():IsAttribute(ATTRIBUTE_EARTH)
	local b2=Duel.IsPlayerCanDraw(tp,1) and c:GetReasonCard():IsRace(RACE_WARRIOR)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
		breakeffect=true
	end
	if b2 and (not breakeffect or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Draw(tp,1,REASON_EFFECT)
		if breakeffect then Duel.BreakEffect() end
	end
end