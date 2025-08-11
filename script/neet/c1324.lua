--崔嵬的凭依装著 奥丝(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,99,s.lcheck)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,{id,1})
	e5:SetCondition(s.spcon2)
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)
end
s.listed_names={97661969}
s.listed_series={0x10c0,0xbf}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH,lc,sumtype,tp) and g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp)
end
function s.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.hspfilter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,zone) 
end
function s.filter(c)
	return (c:IsSetCard(0x10c0) or c:IsSetCard(0xbf)) and c:IsMonster()
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return ct~=0 and zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(s.hspfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_GRAVE,0,nil)
	local ct=math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone))
	if ct<=0 or zone==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,0,LOCATION_GRAVE,1,ct,nil,e,tp,zone)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone) end
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:IsCode(97661969)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and s.filter2(chkc,e,tp)end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	end
	tc:CompleteProcedure()
end