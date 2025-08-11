--The Greatest Duo of the Seven Emperors
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ep==tp and ((d~=nil and d:IsSetCard(0x1048)) or (a~=nil and a:IsSetCard(0x1048)))
end
function s.filter1(c,e,tp)
	local no=c.xyz_number
	return no>=101 and no<=107
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and aux.CheckSummonGate(tp,2)
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(tp,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,2,2,nil,e,tp)
	local sc=g:GetFirst()
	local sc2=g:GetNext()
	if sc and sc2 then
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e3=e1:Clone()
		sc2:RegisterEffect(e3,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true) 
		local e4=e2:Clone()
		sc2:RegisterEffect(e4,true) 
	end
	Duel.SpecialSummonComplete()
	sc:CompleteProcedure() 
	sc2:CompleteProcedure() 
end
