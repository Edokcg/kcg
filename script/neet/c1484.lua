--废铁甲虫(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Special summon itself from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x24}
function s.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x24)
		and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.filter1(c,e,tp,tunc)
	local rg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,tc,e)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and aux.SelectUnselectGroup(rg,e,tp,nil,nil,s.rescon(tunc,c),0)
end
function s.rescon(tuner,scard)
	return  function(sg,e,tp,mg)
				sg:AddCard(tuner)
				local res=Duel.GetLocationCountFromEx(tp,tp,sg,scard)>0 and sg:CheckWithSumEqual(Card.GetLevel,scard:GetLevel(),#sg,#sg)
				sg:RemoveCard(tuner)
				return res
			end
end
function s.filter2(c,e)
	return c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsDestructable(e) and c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc==0 then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
	e:SetLabelObject(sc)
	local rg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,c,e)
	local sg=aux.SelectUnselectGroup(rg,e,tp,nil,nil,s.rescon(c,sc),1,tp,HINTMSG_DESTROY,s.rescon(c,sc))
	Duel.SetTargetCard(sg)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local sg=Duel.GetTargetCards(e)
	if not c or not c:IsRelateToEffect(e) or #sg==0 or not sc then return end
	sg:AddCard(c)
	local lv=sg:GetSum(Card.GetLevel,nil)
	if lv==sc:GetLevel() and Duel.Destroy(sg,REASON_EFFECT+REASON_MATERIAL) and Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
		if not sc:IsSetCard(0x24) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(3206)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
		end
		sc:CompleteProcedure()
	end
end