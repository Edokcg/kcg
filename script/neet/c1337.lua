--电子鱼人-操作员(neet)
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FISH),1,1)
	c:EnableReviveLimit()   
	c:SetSPSummonOnce(id)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e) return e:GetHandler():GetSequence()>4 end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
end
function s.rescon(tuner,scard)
	return  function(sg,e,tp,mg)
				sg:AddCard(tuner)
				local res=Duel.GetLocationCountFromEx(tp,tp,sg,scard)>0 
					and sg:CheckWithSumEqual(Card.GetLevel,scard:GetLevel(),#sg,#sg)
				sg:RemoveCard(tuner)
				return res
			end
end
function s.filter2(c,tp,sc)
	local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true) 
		and aux.SelectUnselectGroup(rg,e,tp,nil,2,s.rescon(c,sc),0)
end
function s.filter3(c)
	return c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
		return #pg<=0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
	if #pg>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g1:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,tuner)
		local sg=aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon(tuner,sc),1,tp,HINTMSG_REMOVE,s.rescon(tuner,sc))
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	sc:CompleteProcedure()
end