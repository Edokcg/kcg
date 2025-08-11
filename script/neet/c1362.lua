--海晶少女的集结(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsSetCard(0x12b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function s.spcheck(sg,e,tp)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.spfilter,tp,0x13,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and aux.SelectUnselectGroup(g,e,tp,3,3,s.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0x13)

end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,0x13,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,s.spcheck,1,tp,HINTMSG_SPSUMMON)
	if #sg==3 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SetLP(tp,math.max(Duel.GetLP(tp)-1500,0))
	end
	--Cannot Special Summon from the Extra Deck, except Dragon Xyz monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_WATER) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
