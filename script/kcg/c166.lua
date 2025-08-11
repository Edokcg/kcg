--ＣＸ－Ｎ・Ａｓ・Ｃｈ Ｋｎｉｇｈｔ
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon procedure
	Xyz.AddProcedure(c,nil,6,3,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()

	--Cannot be destroyed by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--Xyz Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(Cost.DetachFromSelf(1))
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2,false,EFFECT_MARKER_DETACH_XMAT)

    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.con)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e3)
end
s.listed_series={0x48, 0xcf}
s.listed_names={34876719}

function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,34876719)
end

function s.spfilter(c,e,tp,mc,pg)
	local no=c.xyz_number
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
		and no and no>=101 and no<=107
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and (#pg<=0 or pg:IsContains(mc))
		and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
		return (#pg<=0 or (#pg==1 and pg:IsContains(c)))
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,pg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,pg)
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(c)
			Duel.Overlay(sc,c)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
				--Destroy it during your opponent's next End Phase
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabelObject(sc)
				e1:SetCondition(s.descon)
				e1:SetOperation(s.desop)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and e:GetLabelObject():GetFlagEffect(id)>0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	Duel.Destroy(sc,REASON_EFFECT)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcf) and c:IsType(TYPE_XYZ)
	and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.spfilter2(c)
	if not (c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsHasEffect(EFFECT_IMMUNE_EFFECT)) then return false end
	local chk=false
	local ae = {c:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
	for _, te in ipairs(ae) do
		if te:GetOwner() == c and te:GetType() == EFFECT_TYPE_FIELD
		and te:IsActiveType(TYPE_MONSTER)
		and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
        and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
			local a,b=te:GetTargetRange()
			if bit.band(a,LOCATION_ONFIELD)==LOCATION_ONFIELD then
				chk=true
			end
		end
	end
	return chk
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return Duel.IsExistingMatchingCard(s.spfilter2,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.spfilter2,tp,0,LOCATION_MZONE,1,nil) then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD,0)
	for tc in aux.Next(g) do
		local ae = {tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
		for _, te in ipairs(ae) do
			if te:GetOwner() == tc and te:GetType() == EFFECT_TYPE_FIELD
			and te:IsActiveType(TYPE_MONSTER)
			and not te:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
			and not te:GetOwner():IsHasEffect(EFFECT_ULTIMATE_IMMUNE) then
				local a,b=te:GetTargetRange()
				if bit.band(a,LOCATION_ONFIELD)==LOCATION_ONFIELD then
					local te2=te:Clone()
					te:Reset()
					local e0=Effect.CreateEffect(c)
					e0:SetDescription(aux.Stringid(id,3))
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(id)
					e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e0:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD+EVENT_OVERLAY)
					te:GetOwner():RegisterEffect(e0,true)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCountLimit(1,id)
					e1:SetRange(LOCATION_MZONE)
					e1:SetLabelObject(te2)
					e1:SetOperation(s.oop)
					e1:SetReset(RESET_PHASE+PHASE_END)
					te:GetOwner():RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_LEAVE_FIELD)
					e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCountLimit(1,id)
					e2:SetLabelObject(te2)
					e2:SetOperation(s.oop)
					te:GetOwner():RegisterEffect(e2,true)
					local e3=e2:Clone()
					e3:SetCode(EVENT_OVERLAY)
					te:GetOwner():RegisterEffect(e3,true)
					-- local e80 = Effect.CreateEffect(c)
					-- e80:SetType(EFFECT_TYPE_SINGLE)
					-- e80:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
					-- e80:SetRange(LOCATION_ONFIELD)
					-- e80:SetCode(EFFECT_IMMUNE_EFFECT)
					-- e80:SetValue(function(e, te2)
					-- 	return te2 == te
					-- end)
					-- e80:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END)
					-- tc:RegisterEffect(e80)
				end
			end
		end
	end
end
function s.oop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	c:RegisterEffect(te)
	e:Reset()
end