--森罗的山神 谷精(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),8,2)
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(Cost.DetachFromSelf(1))
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:Filter(Card.IsRace,nil,RACE_PLANT)
	if #sg>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
	end
	ct=ct-#sg
	if ct>0 then
		Duel.MoveToDeckBottom(ct,tp)
		Duel.SortDeckbottom(tp,tp,ct)
	end
end
function s.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_PLANT) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ct) end
	local tc=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if tc and tc:IsRelateToEffect(e) and tc:IsLevelBelow(ct) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.SortDecktop(tp,tp,tc:GetLevel())
	end
end