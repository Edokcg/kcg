--混沌的七皇（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetTarget(s.target1)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)

    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(s.drval)
	c:RegisterEffect(e1)

	--cannot attack
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e20:SetRange(LOCATION_SZONE)
	e20:SetTargetRange(LOCATION_MZONE,0)
	e20:SetCondition(s.con)
	c:RegisterEffect(e20)
end
s.listed_series={0x48,0x1048}

function s.filter1(c,e,tp)
	local no=c.xyz_number
	return Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.filter2(c,e,tp,no,tc)
	return c.xyz_number==no and c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and tc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function s.filter3(c,e,tp)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048)  
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.filter5(c,e,tp)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048)  
		and ((not c:IsLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0) 
			or (c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCountFromEx(tp,tp,c)>0)) 
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,no,c)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ect=c92345028 and Duel.IsPlayerAffectedByEffect(tp,92345028) and c92345028[tp]
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc end
	local b1=(loc~=0 and Duel.IsExistingMatchingCard(s.filter1,tp,loc,0,1,nil,e,tp))
	or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	local ect=c92345028 and Duel.IsPlayerAffectedByEffect(tp,92345028) and c92345028[tp]
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc end
	if chk==0 then return (loc~=0 and Duel.IsExistingMatchingCard(s.filter1,tp,loc,0,1,nil,e,tp))
			or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=0
	local ect=c92345028 and Duel.IsPlayerAffectedByEffect(tp,92345028) and c92345028[tp]
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc end
	local g1=Group.CreateGroup()
	if not Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) then
	  if loc==0 then return end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  g1=Duel.SelectMatchingCard(tp,s.filter1,tp,loc,0,1,1,nil,e,tp)
	else g1=Duel.SelectMatchingCard(tp,s.filter5,tp,loc+LOCATION_MZONE,0,1,1,nil,e,tp) end
	local tc1=g1:GetFirst()
	if tc1 then
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

function s.drfilter(c)
	local no=c.xyz_number
	return c:IsFaceup() and c:IsSetCard(0x1048) and no and no>=101 and no<=107 
end
function s.drval(e)
	local g=Duel.GetMatchingGroup(s.drfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	if #g<=0 then return 1 end
	return g:GetCount(Card.GetCode)+1
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.drfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return #g>0
end