--Double-Rank-Up-Magic Hope Force
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsCode(84013237) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==2 and c:IsRankAbove(0)
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,2,nil,rk,e,tp,c)
end
function s.filter2(c,rk,e,tp,tc)
	if c.rum_limit and not c.rum_limit(tc,e) then return false end
	return (c:GetRank()==(rk+1) or c:GetRank()==(rk+2)) 
	  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and aux.CheckSummonGate(tp,2)
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) 
	    and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(tp,2) or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)<2 then return end	  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:GetOverlayCount()~=2 then return end
	local rk=tc:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,2,2,nil,rk,e,tp,tc)
	if #g<2 then return end
	local token = Duel.CreateToken(tp, 84013237)
	g:GetFirst():SetMaterial(Group.FromCards(token))
	g:GetNext():SetMaterial(Group.FromCards(token))
	if Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)<1 then return end
	Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	for sc in aux.Next(g) do
	    local g1=tc:GetOverlayGroup()
		if #g1<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))
		local mg2=g1:Select(tp,1,1,nil)
		Duel.Overlay(sc,mg2)
	end
end