--カオス・フィールド
function c457.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111011002,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c457.condition)
	e2:SetTarget(c457.target)
	e2:SetCost(c457.cost)
	e2:SetOperation(c457.operation)
	c:RegisterEffect(e2)
	--XYZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(457,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c457.target2)
	e3:SetOperation(c457.activate)
	c:RegisterEffect(e3)	
end

function c457.filter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c457.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c457.filter,tp,0,LOCATION_EXTRA,1,nil,e,tp)
end
function c457.ofilter(c)
	return c:GetOverlayCount()~=0 and c:IsSetCard(0x1048) and c:IsFaceup()
end
function c457.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c457.ofilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c457.ofilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	g:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c457.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c457.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)<1 then return end
	local xyzg=Duel.GetMatchingGroup(c457.filter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:RandomSelect(tp,1):GetFirst()
		local rank=xyz:GetRank()+1 
		if rank==0 then return end
		if xyz and Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			xyz:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			xyz:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetOperation(c457.desop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetCountLimit(1)
			xyz:RegisterEffect(e3,true)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			xyz:RegisterEffect(e4,true)
			xyz:RegisterFlagEffect(111011002,RESET_EVENT+0x1fe0000,0,1)
			Duel.SpecialSummonComplete()
		end 
		xyz:CompleteProcedure()
	end 
end
function c457.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c457.filter3(c,e,tp)
	local rank=c:GetRank()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetFlagEffect(111011002)~=0 
		and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0
		and Duel.IsExistingMatchingCard(c457.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,rank,e,tp,c)
end
function c457.xyzfilter(c,rank,e,tp,tc)
	if c:IsCode(6165656) and tc:GetCode()~=48995978 then return false end
	return c:GetRank()==rank+1 and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
	 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) and tc:IsCanBeXyzMaterial(c)
end
function c457.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c457.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c457.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c457.filter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c457.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local sg=Group.CreateGroup()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,tc,TYPE_XYZ)<1 then return end
	local rank=tc:GetRank()
	sg:AddCard(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=Duel.SelectMatchingCard(tp,c457.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,rank,e,tp,tc):GetFirst()
	if not xyz then return end
	local mg=tc:GetOverlayGroup()
	xyz:SetMaterial(sg)
	Duel.BreakEffect()
	if mg:GetCount()~=0 then
		Duel.Overlay(xyz,mg)
	end
	Duel.Overlay(xyz,sg)
	Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
	xyz:CompleteProcedure()
end