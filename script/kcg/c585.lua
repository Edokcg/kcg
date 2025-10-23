--CNo.2 混沌源數之門-負貳 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,2,4,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()

	--cannot destroyed
	  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--selfdes
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCode(EFFECT_SELF_DESTROY)
	-- e2:SetCondition(s.descon)
	-- c:RegisterEffect(e2)

	--Banish and Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.target)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end 
s.xyz_number=4
s.listed_series = {0x1048, 0x14b}
s.listed_names={41418852,4019153}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(4019153) 
	--and Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

-- function s.descon(e)
-- 	local c=e:GetHandler()
-- 	return not Duel.IsExistingMatchingCard(s.damfilter,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
-- end

function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end

function s.filter(c,e,tp)
	local mc=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,c,tp)
	if #g<2 then return false end
	local eff={}
	g:AddCard(mc)
	for tc in aux.Next(g) do
		if not tc:IsXyzLevel(c, 11) then
			local e1=Effect.CreateEffect(mc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(11)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			table.insert(eff,e1)
		end
	end
	local res=c:IsXyzSummonable(nil,g,4,4)
	for _,e1 in ipairs(eff) do
		e1:Reset()
	end
	return c:GetRank()==11 and c.minxyzct and c.maxxyzct and c.maxxyzct>=4
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	and res
	and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.filter2(c,tc,tp)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsFaceup()
	and c:IsSetCard(0x14b) and c:IsSetCard(0x1048)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg<1 then return end
	local sc=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil,sc,tp)
	if #g<2 then return end
	g:AddCard(c)
	local eff={}
	local tc=g:GetFirst()
	while tc do
		if not tc:IsXyzLevel(c, 11) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(11)
			e1:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
			tc:RegisterEffect(e1)
			table.insert(eff,e1)
		end
		tc=g:GetNext()
	end
	Duel.XyzSummon(tp,sc,nil,g)
end

function s.rrfilter(c)
	return c:GetFlagEffect(585)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
			 local g=Duel.GetMatchingGroup(s.rrfilter,tp,LOCATION_MZONE,0,nil)
			 g:AddCard(c)
			 if chk==0 then return g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==4 and Duel.IsExistingMatchingCard(s.filter02,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
			 local g=Duel.GetMatchingGroup(s.rrfilter,tp,LOCATION_MZONE,0,nil)
			 g:AddCard(c)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	 local g2=Duel.SelectMatchingCard(tp,s.filter02,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
			 local sc=g2:GetFirst()
			 local gg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	 local tc2=gg:GetFirst()
	while tc2 do
						local mg=tc2:GetOverlayGroup()
				if mg:GetCount()~=0 then
						 Duel.Overlay(sc,mg)
				end
						tc2=gg:GetNext()
	end
			sc:SetMaterial(gg)
	Duel.Overlay(sc,gg)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure() 
end