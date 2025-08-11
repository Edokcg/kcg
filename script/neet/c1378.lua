--正义盟军 决战头脑(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(s.indcon)
	e3:SetOperation(s.indop)
	c:RegisterEffect(e3)
end
s.listed_series={0x1}
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_MZONE,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0x13)
end
function s.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.attfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ATTRIBUTE_LIGHT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			tc:RegisterEffect(e1)
		end
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	local lc=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_LIGHT)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	lc=math.min(lc,ft)
	Duel.BreakEffect()
	local lg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,0x13,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(lg,e,tp,1,lc,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsLevelAbove(10)
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3110)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	e1:SetOwnerPlayer(tp)
	rc:RegisterEffect(e1)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end