--輪廻の海 (K)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--对方特召时特召
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35699,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	  e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.tkcon)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	  local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	  local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.listed_series={0x552}

function s.tkfilter(c,e,tp)
	return (not e or c:IsRelateToEffect(e)) and c:IsControler(1-tp)
end
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tkfilter,1,nil,nil,tp)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x552)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  local eeg=eg:Filter(s.tkfilter,nil,nil,tp)
	  local tc=eeg:GetFirst()
	  while tc do
	  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	  if g:GetCount()>0 then
	  local tc2=g:GetFirst()
	  Duel.SpecialSummon(tc2,0,tp,tp,true,false,POS_FACEUP)
	  tc=eeg:GetNext() end end end
end
