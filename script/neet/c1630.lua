--救援小熊猫 
function c1630.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1630,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1630)
	e1:SetCost(c1630.spcost)
	e1:SetTarget(c1630.sptg)
	e1:SetOperation(c1630.spop)
	c:RegisterEffect(e1)
end
function c1630.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1630.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1630.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetMZoneCount(tp,e:GetHandler())
		and g:GetClassCount(Card.GetLevel)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c1630.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1630.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetLevel)>=2 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(1630,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=sg:GetNext()
		end
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c1630.descon)
		e3:SetOperation(c1630.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c1630.desfilter(c,fid)
	return c:GetFlagEffectLabel(1630)==fid
end
function c1630.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1630.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1630.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c1630.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end