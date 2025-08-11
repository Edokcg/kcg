--六芒星之龙穴 （ZCG）
function c77240236.initial_effect(c)
  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77240236.cost)
	e1:SetTarget(c77240236.tg)
	e1:SetOperation(c77240236.op)
	c:RegisterEffect(e1)
end
function c77240236.filter(c,e,tp)
	return c:IsCode(77239401) or c:IsCode(77240238) or c:IsCode(77239405) or c:IsCode(77239402) or c:IsCode(77239406) or c:IsCode(77239404) or c:IsCode(77239403) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240236.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_COST) 
end
function c77240236.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240236.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77240236.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240236.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
	  if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
	   local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
end