--Rank-Up-Magic Admire Des Thousand
local s, id = GetID()
function s.initial_effect(c)
	--Special Summon and Rank-Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13732,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)	

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94220427,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
end
s.listed_series = {0x1048, 0x14b}

function s.filter1(c,e,tp)
	local rk=c:GetRank()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and c:IsType(TYPE_XYZ) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,rk,e,tp,c) and c:IsRankAbove(0)
		and c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.filter2(c,e,tp,rk)
	if c.rum_limit and not c.rum_limit(tc,e) then return false end
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetRank()==rk and c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,rk,e,tp,c) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.filter3(c,rk,e,tp,tc)
	return c:GetRank()==rk+10 and c:IsSetCard(0x1048) and c:IsSetCard(0x14b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and tc:IsCanBeXyzMaterial(c,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,g:GetFirst(),e,tp,g:GetFirst():GetRank()) then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.SelectYesNo(tp,aux.Stringid(6459419,0)) then
	local g2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,Duel.GetLocationCount(tp,LOCATION_MZONE),g:GetFirst(),e,tp,g:GetFirst():GetRank())
	  g:Merge(g2) end end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) then return end
	if ft<=0 then return end
	local ag=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not ag or #ag<=0 then return end
	local g=ag:Filter(Card.IsRelateToEffect,nil,e)
	if #g<=0 then return end
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
	local lesser=false
	if sg:GetCount()<1 then return end
	if ft<sg:GetCount() then
	   lesser=true
	end
	if lesser==true then
	   if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg2=sg:Select(tp,ft,ft,nil)
	   sg=sg2 
	end
	if sg:GetCount()>ft then return end
	local chk=0
	local tsc=sg:GetFirst()
	local tscg=Group.CreateGroup()
	for i=1,sg:GetCount() do
		if i==sg:GetCount() and Duel.GetLocationCountFromEx(tp,tp,tscg,TYPE_XYZ)<1 then
			local zone=0
			for j=0,4 do
				if Duel.CheckLocation(tp,LOCATION_MZONE,j) then zone=zone|0x1<<j end
			end  
			Duel.SpecialSummon(tsc,0,tp,tp,false,false,POS_FACEUP,zone)
		else 
			Duel.SpecialSummon(tsc,0,tp,tp,false,false,POS_FACEUP) 
		end
		tscg:AddCard(tsc)
		tsc=sg:GetNext()
	end
	Duel.BreakEffect()
	if tscg:GetCount()<1 then return end
	local xg=tscg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local ct=xg:GetCount()
	if ct<1 then return end
	local xyzg=Group.CreateGroup()
	for sc in aux.Next(xg) do
		xyzg:Merge(Duel.GetMatchingGroup(s.filter3,tp,LOCATION_EXTRA,0,nil,sc:GetRank(),e,tp,sc))
	end 
	if xyzg:GetCount()>0 then
		if Duel.GetLocationCountFromEx(tp,tp,xg,TYPE_XYZ)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=xyzg:Select(tp,1,1,nil):GetFirst()
		if not sc then return end
		sc:SetMaterial(xg)
		Duel.Overlay(sc,xg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure() 
	end
end

function s.cfilter(c,tp)
	return c:IsRankAbove(12) and c:IsSetCard(0x14b) and c:IsPreviousControler(tp) and c:IsType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.filter(c,e,tp)
	local g=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,c,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and #g>0
	and c:IsXyzSummonable(nil,g) and c.minxyzct
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function s.filter4(c,tc,tp)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsFaceup() 
	and c:IsSetCard(0x14b) and c:IsType(TYPE_XYZ)
	and (not tc.xyz_filter or tc.xyz_filter(c,false,tc,tp))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		local sc=g:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp, s.filter4, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, sc.minxyzct, sc.maxxyzct, nil, sc, tp)
		if #g2<1 then return end
		Duel.XyzSummon(tp,sc,nil,g2)
	end
end