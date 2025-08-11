--欧贝利斯克之暗忍加藤(ZCG)
local s,id=GetID()
function s.initial_effect(c)
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	 --cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_MZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_MZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_MZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_MZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)  
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end 
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xa220) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) or (Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil))end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if op==0  and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ft=2
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,ft,ft,nil,e,tp)
			if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	elseif op==1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		g:Merge(g2)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end