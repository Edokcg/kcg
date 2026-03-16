--カオス・フィールド
local s,id=GetID()
function s.initial_effect(c)
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
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetCost(s.cost)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--XYZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(457,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)	
end

function s.filter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_EXTRA,1,nil,e,tp)
end
function s.ofilter(c,tp)
	return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:IsSetCard(0x1048) and c:IsFaceup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,s.ofilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	g:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)<1 then return end
	local xyzg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_EXTRA,nil,e,tp)
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
			e3:SetOperation(s.desop)
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
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.filter3(c,e,tp)
	local rank=c:GetRank()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetFlagEffect(111011002)~=0 
		and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0
		and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,rank,e,tp,c)
end
function s.xyzfilter(c,rank,e,tp,tc)
	if c:IsCode(6165656) and tc:GetCode()~=48995978 then return false end
	return c:GetRank()==rank+1 and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
	 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) and tc:IsCanBeXyzMaterial(c)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local sg=Group.CreateGroup()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,tc,TYPE_XYZ)<1 then return end
	local rank=tc:GetRank()
	sg:AddCard(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,rank,e,tp,tc):GetFirst()
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