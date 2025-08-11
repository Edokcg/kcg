--不死之英雄假面(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg2)
	e1:SetOperation(s.thop2)
	c:RegisterEffect(e1)
end
function s.thfilter2(c,id,e,tp)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_MONSTER) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chk==0 then return Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tid,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	 local tid=Duel.GetTurnCount()
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	 if ft<=0 then return end
	 if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	 local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,ft,ft,nil,tid,e,tp)
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end