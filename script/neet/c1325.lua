--侵略的泛发袭击(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xa}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter1(c,e,tp)
	return c:HasLevel() and c:IsSetCard(0xa)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,e,tp) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,c:GetLevel(),c:GetCode())
end
function s.filter2(c,e,tp,dc,dlv,code)
	return c:HasLevel() and c:IsSetCard(0xa) and c:IsLevel(dlv) 
		and not c:IsCode(code) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(dc,c))
end
function s.filter3(c,e,tp,sg)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil,sg,2,2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local dc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not dc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local gc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,dc,dc:GetLevel(),dc:GetCode()):GetFirst()
	local sg=Group.FromCards(dc,gc)
	if #sg<2 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==2 then
		local xyzg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,sg)
		if #xyzg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,nil,sg)
		end
	end
end
