--Numeron Direct
local s, id = GetID()
function s.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77402960,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={41418852}
s.listed_series={0x14b}

function s.filter1(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function s.filter(c,e,tp)
	return c:GetAttack()==0 and c:IsSetCard(0x14b)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return 
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>3 
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,4,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=0
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end   
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,4,4,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	local de=Effect.CreateEffect(c)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetRange(LOCATION_MZONE)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetCountLimit(1)
	de:SetOperation(s.rmop)
	de:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(de,true)
						tc:CompleteProcedure()
				tc=g:GetNext()
			end
						Duel.SpecialSummonComplete()
		end
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
