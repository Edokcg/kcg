--阿不思的异端
function c1642.initial_effect(c)
	--code list
	aux.AddCodeList(c,68468459)
	-- change code
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1642,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,1642)
	e1:SetCost(c1642.cost)
	e1:SetTarget(c1642.target)
	e1:SetOperation(c1642.operation)
	c:RegisterEffect(e1)
end
function c1642.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c1642.fcheck(c)
	return function(tp,sg,fc)
				return not sg:IsExists(Card.IsLocation,1,c,LOCATION_HAND)
			end
end
function c1642.costfilter(c,tp)
	if (c:GetSequence()<5 and c:IsType(TYPE_MONSTER)) or c:IsLocation(LOCATION_SZONE) then
		if Duel.GetMZoneCount(tp,c)<=0 then
			return end
	end
	return c:IsAbleToGraveAsCost()
end
function c1642.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c1642.tfilter2(c,e,tp,m,f,gc,chkf,cg)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,gc,2)
		and Duel.GetLocationCountFromEx(tp,tp,cg,c)>0
end
function c1642.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,gc,chkf)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1642.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c1642.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c1642.filter1,tp,0,LOCATION_GRAVE,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c1642.fcheck(c)
		local res=Duel.IsExistingMatchingCard(c1642.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf,cg)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c14504055.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,c,chkf,cg)
			end
		end
		aux.FCheckAdditional=nil
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=cg:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c1642.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local c=e:GetHandler()
	if Duel.GetCurrentPhase()&PHASE_DAMAGE~=0 or Duel.GetCurrentPhase()&PHASE_DAMAGE_CAL~=0 then return end
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(c1642.filter1,tp,0,LOCATION_GRAVE,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=c1642.fcheck(c)
	local sg1=Duel.GetMatchingGroup(c1642.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1642.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			local res=mat1:IsExists(Card.IsControler,1,nil,tp) and mat1:IsExists(Card.IsControler,1,nil,1-tp)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end