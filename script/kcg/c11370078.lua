--Glorious Seven
local s, id = GetID()
function s.initial_effect(c)
	--act qp in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.AND(s.spcost,Cost.SelfBanish))
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0x1073,0x1048}

function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.xfilter2),tp,LOCATION_GRAVE|LOCATION_REMOVED,LOCATION_GRAVE|LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.xfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.xfilter2),tp,LOCATION_GRAVE|LOCATION_REMOVED,LOCATION_GRAVE|LOCATION_REMOVED,1,99,nil)
		if #g>0 then
			Duel.Overlay(tc,g)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tp~=Duel.GetTurnPlayer() then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_PHASE+PHASE_END)
				e3:SetOperation(s.lpop)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetCountLimit(1)
				e3:SetLabel(Duel.GetLP(1-tp))
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	if Duel.GetLP(1-tp)>e:GetLabel() then
		Duel.SetLP(tp,Duel.GetLP(1-tp)-e:GetLabel(),REASON_EFFECT)
	else
		Duel.SetLP(tp,e:GetLabel()-Duel.GetLP(1-tp),REASON_EFFECT)
	end
end

function s.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
	and Duel.IsBattlePhase()
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.actcostfilter(c)
	return c:IsCode(57734012) and c:IsAbleToRemoveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.actcostfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.filter1(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (aux.CheckSummonGate(tp,2) or not c:IsLocation(LOCATION_EXTRA))
		and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,tc)
	if c.rum_limit and not c.rum_limit(tc,e) then return false end
	return c:ListsCode(tc:GetCode()) and c:IsSetCard(0x914) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and tc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function s.filter3(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c)))
	and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter5(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c)))
	    and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
		and ((not c:IsLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)    
		    and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
		    and (aux.CheckSummonGate(tp,2) or not c:IsLocation(LOCATION_EXTRA))) 
		  or (c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCountFromEx(tp,tp,c)>0)) 
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE+LOCATION_REMOVED end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 then loc=loc+LOCATION_EXTRA end
	if chk==0 then return (loc~=0 and Duel.IsExistingMatchingCard(s.filter1,tp,loc,0,1,nil,e,tp))
			or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc+LOCATION_EXTRA end
	local g1=Group.CreateGroup()
	if not Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		if loc==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g1=Duel.SelectMatchingCard(tp,s.filter1,tp,loc,0,1,1,nil,e,tp)
	else
		g1=Duel.SelectMatchingCard(tp,s.filter5,tp,loc+LOCATION_MZONE,0,1,1,nil,e,tp)
	end
	local tc1=g1:GetFirst()
	if tc1 then
		if not tc1:IsLocation(LOCATION_MZONE) then
		if Duel.SpecialSummonStep(tc1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
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
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1)
		local tc2=g2:GetFirst()
		if tc2 then
			local mg=tc1:GetOverlayGroup()
			Duel.BreakEffect()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc2,mg)
			end
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
			Duel.Damage(tp,tc2:GetAttack(),REASON_EFFECT)
		end
	end
end