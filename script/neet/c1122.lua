--神星去往的尽头(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E) 
	e1:SetCondition(s.condition) 
	e1:SetTarget(s.target)  
	e1:SetOperation(s.operation)  
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.spcon)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_names={29432356,85216896}
s.listed_series={0xc4}
function s.filter(c)
	return c:IsSetCard(0xc4) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)  
end 
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end  
function s.operation(e,tp,eg,ep,ev,re,r,rp)  
	local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if Duel.SendtoHand(dg,nil,REASON_EFFECT) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
			end
		--Other monsters cannot attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	   end
	end
end  
function s.spfilter(c,e,tp)
	return c:IsCode(29432356) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.atktg(e,c)
	return not c:IsCode(29432356)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.spfilter2(c,e,tp)
	return c:IsCode(85216896) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end