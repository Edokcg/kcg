--Rank-Up-Magic The Seventh One
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x48,0x1048}

function s.filter1(c,e,tp)
	local no=c.xyz_number
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (aux.CheckSummonGate(tp,2) or not c:IsLocation(LOCATION_EXTRA))
		and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.filter2(c,e,tp,no,tc)
	if c.rum_limit and not c.rum_limit(tc,e) then return false end
	return c.xyz_number==no and c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and tc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function s.filter3(c,e,tp)
	local no=c.xyz_number
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048)
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.filter5(c,e,tp)
	local no=c.xyz_number
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048)
		and ((not c:IsLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)    
		    and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
		    and (aux.CheckSummonGate(tp,2) or not c:IsLocation(LOCATION_EXTRA))) 
		  or (c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCountFromEx(tp,tp,c)>0)) 
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE+LOCATION_REMOVED end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 then loc=loc+LOCATION_EXTRA end
	if chk==0 then return (loc~=0 and Duel.IsExistingMatchingCard(s.filter1,tp,loc,0,1,nil,e,tp))
			or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc+LOCATION_EXTRA end
	local g1=Group.CreateGroup()
	if not Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) then
	  if loc==0 then return end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  g1=Duel.SelectMatchingCard(tp,s.filter1,tp,loc,0,1,1,nil,e,tp)
	else g1=Duel.SelectMatchingCard(tp,s.filter5,tp,loc+LOCATION_MZONE,0,1,1,nil,e,tp) end
	local tc1=g1:GetFirst()
	if tc1 then
		if not tc1:IsLocation(LOCATION_MZONE) then
		if Duel.SpecialSummonStep(tc1,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		tc1:CompleteProcedure() end end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1.xyz_number,tc1)
		local tc2=g2:GetFirst()
		if tc2 then
				  local mg=tc1:GetOverlayGroup()
				  Duel.BreakEffect()
			  if mg:GetCount()~=0 then
			   Duel.Overlay(tc2,mg)
			  end 
			  tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
			tc2:CompleteProcedure()
		end
	end
end