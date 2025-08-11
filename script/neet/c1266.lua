--ZZ-机甲履带（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,2,2,s.lcheck)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tecon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.tetg)
	e1:SetOperation(s.teop)
	c:RegisterEffect(e1)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e9:SetValue(64500000)
	c:RegisterEffect(e9) 

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
s.listed_names={62651957,65622692,64500000}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_MACHINE,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,scard,sumtype,tp)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsCode,1,nil,64500000,sumtype,tp)
end
function s.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g<1 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function s.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsRace(RACE_MACHINE)
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end


