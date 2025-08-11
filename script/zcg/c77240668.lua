--不死之魔羊(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77240669,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_ZOMBIE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77240669,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_ZOMBIE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then
		for i=1,4 do
			local token=Duel.CreateToken(tp,77240669)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end