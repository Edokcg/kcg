--陰陽合祀 (K)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35699,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	  e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_names={1686814}

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==10 and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then 
		local rc=eg:Filter(Card.IsCode,nil,1686814)
		return (not ect or ect>=2) and Duel.GetLocationCountFromEx(tp,tp,nil,SUMMON_TYPE_SYNCHRO)>1 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
				and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)   
				   and rc:GetCount()>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end 
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,SUMMON_TYPE_SYNCHRO)
	if ft<=1 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,2,2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(0)
		tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
