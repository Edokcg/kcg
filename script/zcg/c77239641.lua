--植物的愤怒 绿色超融合
local s,id=GetID()
function s.initial_effect(c)
	--Activate 
	local e1=Fusion.CreateSummonEff{handler=c,fusfilter=aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),matfilter=Fusion.OnFieldMat(Card.IsAbleToRemove),extrafil=s.fextra,extratg=s.extratg,extraop=Fusion.BanishMaterial,stage2=s.stage2}
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.stage2(e,tc,tp,mg,chk)
	local c=e:GetHandler()
	if chk==2 then
		local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsMonster),tp,0,LOCATION_MZONE|LOCATION_GRAVE,nil)
		if #g==0 then return end
		for tc in g:Iter() do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_PLANT)
			tc:RegisterEffect(e1)
		end
	end
end
function s.cfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,gc)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,gc,c)>0 
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,3,false,nil,nil,e,tp) end
	local rg=Duel.SelectReleaseGroupCost(tp,s.cfilter,3,3,false,nil,nil,e,tp)
	Duel.Release(rg,REASON_COST)
	Duel.SetChainLimit(aux.FALSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local sg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsMonster),tp,0,LOCATION_MZONE|LOCATION_GRAVE,nil)
	if #sg==0 then return end
	for tc in sg:Iter() do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_PLANT)
		tc:RegisterEffect(e1)
	end
end