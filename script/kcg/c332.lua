--壓力Endo (K)
local s,id=GetID()
function s.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(s.condition)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x503}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp) and e:GetHandler():IsReason(REASON_DESTROY)
end
function s.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x503)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
      if g:GetCount()>0 then 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
      if g:GetCount()>0 then 
      Duel.Destroy(g,REASON_EFFECT) end
      local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil,e,tp)
      local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
      if ft>0 and g2:GetCount()>0 then
          if ft>g2:GetCount() then ft=g2:GetCount() end
		  if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
          Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	      local g3=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,ft,ft,nil,e,tp)
	      if g3:GetCount()>0 then Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP) end end
end
