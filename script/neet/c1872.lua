--氕素龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	e0:SetValue(22587018)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.target)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
s.listed_names={22587018,58071123}
s.listed_series={0x100}
function s.cfilter(c,e,tp)
	return c:IsSpellTrap() and c:IsSetCard(0x100) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
	local chk=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,58071123),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	return c:IsCanBeSpecialSummoned(e,0,tp,chk,false) and tc:ListsCode(c:GetOriginalCode())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local chk=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,58071123),tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp,tc)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,chk,false,POS_FACEUP)
	end
end