local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),5,5,s.lcheck)
	c:EnableReviveLimit()
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(791,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)

	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(33015627,1))
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END) 
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(s.tdtg)
	e7:SetOperation(s.tdop)
	c:RegisterEffect(e7)
end
s.listed_names={511600365}

function s.lcheck(g,lc,tp)
	return g:FilterCount(function(c) return c:IsAttribute(ATTRIBUTE_WIND) end,nil)==5
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.atkfilter(c,tc)
	return not tc:GetLinkedGroup():IsContains(c) and c:IsAbleToDeck()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil,c)
	if chkc then return s.atkfilter(chkc,tc) and chkc:IsControler(1-tp) end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.atkfilter,tp,0,LOCATION_MZONE,1,g:GetCount(),nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

function s.spfilter(c,e,tp)
	return c:IsCode(511600365)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)<1 then return end
	if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end end
end