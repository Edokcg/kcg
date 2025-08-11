--空无的碎石(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	 local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SSET)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e7)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re and re:GetHandler():IsSetCard(0xa160)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
		Duel.ShuffleHand(tp)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa160)
end
function s.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	local cct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if cct<ct then return end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,ct,ct,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
	end
   Duel.SpecialSummonComplete()
end













