--Legend of Heart
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35699,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={281,280,282,293,294,295}

function s.costfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.cost2filter(c,tp)
	return c:IsRace(RACE_WARRIOR) 
	--and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)>2
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.CheckReleaseGroup(tp,s.cost2filter,1,nil,tp) 
	--   and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,281)
	--   and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,280)
	--   and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,282)
	end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	-- local g1=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,281)
	-- if #g1<1 then return end
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	-- local g2=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,280)
	-- if #g2<1 then return end
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	-- local g3=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,282)
	-- if #g3<1 then return end
	-- g1:Merge(g2)
	-- g1:Merge(g3)
	-- Duel.DisableShuffleCheck()
	-- Duel.Remove(g1,POS_FACEUP,REASON_COST)
	-- Duel.DisableShuffleCheck()
	Duel.Release(rg,REASON_COST)
end
function s.filter3(c,e,tp,code)
	return c:IsFaceup() and (c:IsCode(281) or c:IsCode(280) or c:IsCode(282))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,281,e,tp)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,280,e,tp)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,282,e,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1784686,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11082056,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46232525,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not Duel.IsPlayerCanSpecialSummonMonster(tp,1784686,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP) or not Duel.IsPlayerCanSpecialSummonMonster(tp,11082056,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP) or not Duel.IsPlayerCanSpecialSummonMonster(tp,46232525,0,TYPE_MONSTER+TYPE_EFFECT,2800,1800,8,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP) then return end	   
	-- local tc1=Duel.CreateToken(tp,293,nil,nil,nil,nil,nil,nil)
	-- local tc2=Duel.CreateToken(tp,294,nil,nil,nil,nil,nil,nil)
	-- local tc3=Duel.CreateToken(tp,295,nil,nil,nil,nil,nil,nil)
	if not (Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,281,e,tp)
	and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,280,e,tp)
	and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,282,e,tp)) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	--Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
	if ft<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,281,e,tp)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,280,e,tp)
	if #g2<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,282,e,tp)
	if #g3<1 then return end
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	local tc3=g3:GetFirst()
	tc1:AddMonsterAttribute(TYPE_EFFECT)
	tc2:AddMonsterAttribute(TYPE_EFFECT)
	tc3:AddMonsterAttribute(TYPE_EFFECT)
	if not Duel.SpecialSummonStep(tc1,0,tp,tp,true,true,POS_FACEUP) or not Duel.SpecialSummonStep(tc2,0,tp,tp,true,true,POS_FACEUP) or not Duel.SpecialSummonStep(tc3,0,tp,tp,true,true,POS_FACEUP) then return end
	-- Duel.SendtoDeck(tc1,tp,0,REASON_RULE)
	-- Duel.SendtoDeck(tc2,tp,0,REASON_RULE)
	-- Duel.SendtoDeck(tc3,tp,0,REASON_RULE)
	tc1:AddMonsterAttributeComplete()
	tc2:AddMonsterAttributeComplete()
	tc3:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
	tc1:CompleteProcedure()
	tc2:CompleteProcedure()
	tc3:CompleteProcedure()
	Duel.BreakEffect()
	tc1:SetEntityCode(293,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
    aux.CopyCardTable(293,tc1)
	tc2:SetEntityCode(294,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
    aux.CopyCardTable(294,tc2)
	tc3:SetEntityCode(295,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
    aux.CopyCardTable(295,tc3)
end
