--爆裂同调士(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.condition)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_ASSAULT_MODE}
s.listed_series={0x104f}
function s.costfilter(c,tc,e,tp)
	return c:IsSetCard(0x104f) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,c.assault_mode,e,tp,tc)
end
function s.filter(c,tcode,e,tp,tc)
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,tc)
	local remain_level=c:GetLevel()-tc:GetLevel()
	if remain_level<1 then return false end
	return c:IsType(TYPE_SYNCHRO) and c:IsCode(tcode) and mg:CheckWithSumEqual(Card.GetLevel,remain_level,1,99)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.mfilter(c)
	return c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function s.thfilter(c)
	return c:IsCode(CARD_ASSAULT_MODE) and c:IsSSetable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp) end
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil,c,e,tp)
	if #g>0 then 
		e:SetLabel(g:GetFirst().assault_mode)
		Duel.ConfirmCards(1-tp,g) 
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler(),e,tp)
			and e:GetHandler():IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e:GetLabel(),e,tp,e:GetHandler())
		or not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		or not e:GetHandler():IsAbleToRemove() then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel(),e,tp,e:GetHandler())
	if #g>0 then
		local remain_level=g:GetFirst():GetOriginalLevel()-c:GetLevel()
		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
		if mg:CheckWithSumEqual(Card.GetLevel,remain_level,1,99) then 

			local mg2=mg:SelectWithSumEqual(tp,Card.GetLevel,remain_level,1,99)
			mg2:AddCard(c)
			Duel.Remove(mg2,POS_FACEUP,REASON_EFFECT)

			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:GetFirst()
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()

			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
			--ATK/DEF becomes 0
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			sc:RegisterEffect(e4,true)

			local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #sg>0 then Duel.SSet(tp,sg) end
	
		end 
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.hspfilter(c,e,tp)
	return c:IsSetCard(0x104f) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD_DISABLE,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
end