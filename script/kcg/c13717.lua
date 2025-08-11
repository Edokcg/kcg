--Numeron Chaos Ritual
local s, id = GetID()
function s.initial_effect(c)
--Activate
aux.GlobalCheck(s,function()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_DESTROYED)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0)
end)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8387138,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series = {0x48, 0x14b}
s.listed_names={41418852}

function s.cfilter(c)
	return c:IsSetCard(0x14b) and c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.filter(c,e,tp)
	local mc=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,c,tp)
	local eff={}
	for tc in aux.Next(g) do
		if tc:IsSetCard(0x48) and not tc:IsXyzLevel(c, 12) then
			local e1=Effect.CreateEffect(mc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(12)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			table.insert(eff,e1)
		end
		if tc:IsCode(41418852) then
			tc:AssumeProperty(ASSUME_TYPE,tc:GetType()|TYPE_MONSTER)
			local e3=Effect.CreateEffect(mc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCode(EFFECT_XYZ_LEVEL)
			e3:SetValue(12)
			e3:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e3)
			table.insert(eff,e3)
		end
	end
	local res=c:IsXyzSummonable(nil,g)
	for _,e1 in ipairs(eff) do
		e1:Reset()
	end
	if g:FilterCount(Card.IsCode,nil,41418852)>0 then 
		Duel.AssumeReset() 
	end
	return c.minxyzct
	and res
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.filter2(c,tc,tp)
	return c:IsFaceup() and (c:IsCode(41418852) or c:IsSetCard(0x48) or c:IsXyzLevel(tc, 12))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mc=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, sc.minxyzct, sc.maxxyzct, nil, sc, tp)
		if #g2<sc.minxyzct then return end
		local eff={}
		for tc in aux.Next(g2) do
			if tc:IsSetCard(0x48) and not tc:IsXyzLevel(sc, 12) then
				local e1=Effect.CreateEffect(mc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_XYZ_LEVEL)
				e1:SetValue(12)
				e1:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
				tc:RegisterEffect(e1)
				table.insert(eff,e1)
			end
			if tc:IsCode(41418852) then
				tc:AssumeProperty(ASSUME_TYPE,tc:GetType()|TYPE_MONSTER)
				local e3=Effect.CreateEffect(mc)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetCode(EFFECT_XYZ_LEVEL)
				e3:SetValue(12)
				e3:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVED)
				tc:RegisterEffect(e3)
				table.insert(eff,e3)
			end
		end
		Duel.Hint(HINT_MUSIC,tp,aux.Stringid(828, 6))
		Duel.Hint(HINT_BGM,tp,aux.Stringid(828, 5))
		if sc:IsXyzSummonable(nil,g2) then
			sc:SetMaterial(g2)
			Duel.Overlay(sc,g2)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			if g2:FilterCount(Card.IsCode,nil,41418852)>0 then 
				Duel.AssumeReset() 
			end
		end
		-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		-- Duel.XyzSummon(tp,sc,nil,g2)
	end
end
