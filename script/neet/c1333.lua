--黑羽-阴风之帕森(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)	
end
s.listed_series={0x33}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.spfilter(c,e,tp,tc)
	local clv=c:GetLevel()-tc:GetLevel()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,tc)
	return c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)
		and Duel.GetLocationCountFromEx(tp)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and g:CheckWithSumEqual(Card.GetLevel,clv,1,99)
end
function s.filter(c)
	return c:IsSetCard(0x33) and c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:HasLevel() and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
	if not sc then return end
	local clv=sc:GetLevel()-c:GetLevel()
	local rg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=rg:SelectWithSumEqual(tp,Card.GetLevel,clv,1,99)
	g:AddCard(c)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3207)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCondition(s.descon)
		e2:SetOperation(s.desop)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetLabelObject(sc)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
	sc:CompleteProcedure()
	local ac=Duel.GetAttacker()
	if sc:IsLocation(LOCATION_MZONE) and ac and not ac:IsImmuneToEffect(e) then
		Duel.BreakEffect()
		Duel.CalculateDamage(ac,sc)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end