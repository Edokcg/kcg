--Ritual Refinement
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series = {0x505}

function s.filter2(c)
	return c:IsSetCard(0x505) and c:IsFaceup()
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x505) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
      local count=Duel.GetMatchingGroupCount(s.filter2,tp,LOCATION_MZONE,0,nil)
      local gcount=count*2
      local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and count>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
      if gcount>ft then gcount=ft end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gcount,tp,LOCATION_DECK)
      e:SetLabel(gcount)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end	  			
    local gcount=e:GetLabel()
    if gcount>ft then gcount=ft end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,gcount,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
