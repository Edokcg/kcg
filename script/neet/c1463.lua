--升阶魔法-叛逆之力(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xba,0x10db,0x13b}
function s.filter1(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return #pg<=1 and c:IsAttribute(ATTRIBUTE_DARK) and (c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2,pg)
end
function s.filter2(c,e,tp,mc,rk,pg)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:IsSetCard(0x13b) and c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and mc:IsCanBeXyzMaterial(c,tp) and (#pg<=0 or pg:IsContains(mc)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc:IsSetCard(0xba) or tc:IsSetCard(0x10db) or tc:IsSetCard(0x13b) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2,pg)
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,tc)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		if e:GetLabel()==1 then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetRange(0xff)
			e0:SetCode(EVENT_CHAINING)
			e0:SetLabelObject(sc)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetOperation(s.actop)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e0,true)
		else
			-- Cannot attack
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			-- Effects are negated
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e3)
		end
		sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		Duel.SpecialSummonComplete()
		sc:CompleteProcedure()
	end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc==e:GetLabelObject() then
		Duel.SetChainLimit(function(e,rp,tp) return tp==rp end)
	end
end