--守护龙 福斯可忒罗(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,nil,nil,nil,false,s.xyzcheck)  
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,{id,0})
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_names={id}
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_LINK,xyz,sumtype,tp) and c:IsRace(RACE_DRAGON,xyz,sumtype,tp)
end
function s.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetRank)==1
end
function s.splimit(e,c)
	return c:GetRace()~=RACE_DRAGON
end

function s.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3312)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end