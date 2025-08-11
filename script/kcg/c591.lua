--Numeronius the Divine Giant
local s, id = GetID()
function s.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98777036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
end
s.listed_series={0x95}

function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return tg:GetSummonType()==SUMMON_TYPE_XYZ and tg:IsControler(tp)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	    Duel.SendtoHand(g,nil,REASON_EFFECT) end
	end
end
