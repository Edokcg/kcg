--奥金魔杖(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e6=Effect.CreateEffect(c)
	e6:SetCode(EVENT_ADJUST)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(0xff)
	e6:SetTarget(s.adtg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_END)
	e7:SetTarget(s.adtg2)
	c:RegisterEffect(e7)  

	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)  
end

s.material_race=RACE_SPELLCASTER
s.material_type=TYPE_SYNCHRO
function s.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=1 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown()then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(function(e) return Duel.GetCounter(0,1,1,COUNTER_SPELL)*500 end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EFFECT_DESTROY_REPLACE)
		e4:SetTarget(s.reptg)
		e4:SetOperation(s.repop)
		c:RegisterEffect(e4)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_DESTROY_REPLACE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTarget(s.desreptg)
		c:RegisterEffect(e3)
		Duel.BreakEffect()
		if not tc:IsCanAddCounter(COUNTER_SPELL,1) then
			tc:EnableCounterPermit(COUNTER_SPELL,LOCATION_MZONE,c:GetEquipTarget()==tc)
		end
		tc:AddCounter(COUNTER_SPELL,2,true)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (r&REASON_EFFECT)~=0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and Duel.IsCanRemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_REPLACE) end
	return Duel.SelectYesNo(e:GetOwnerPlayer(),aux.Stringid(id,0))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_REPLACE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsCanRemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_REPLACE) end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.RemoveCounter(tp,1,0,COUNTER_SPELL,2,REASON_REPLACE)
		return true
	else return false end
end

function s.adfilter(c)
	return c:GetFlagEffect(id)==0 and c:IsCode(46232525)
end
function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.adfilter,tp,0xff,0xff,1,nil) end
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(0,id,0,0,0) Duel.RegisterFlagEffect(1,id,0,0,0)
	local g=Duel.GetMatchingGroup(s.adfilter,tp,0xff,0xff,nil)
	for tc in aux.Next(g) do
	  local e3=Effect.CreateEffect(c)
	  e3:SetDescription(aux.Stringid(id,0))
	  e3:SetType(EFFECT_TYPE_ACTIVATE)
	  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	  e3:SetCode(EVENT_FREE_CHAIN)
	  e3:SetCountLimit(1,46232525)
	  e3:SetTarget(s.target)
	  e3:SetOperation(s.activate)
	  tc:RegisterEffect(e3,true)
	  tc:RegisterFlagEffect(id,0,0,0)
	end 
end
function s.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.adfilter,tp,0xff,0xff,1,nil)end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.adfilter,tp,0xff,0xff,nil)
	for tc in aux.Next(g) do
	  local e3=Effect.CreateEffect(c)
	  e3:SetDescription(aux.Stringid(id,0))
	  e3:SetType(EFFECT_TYPE_ACTIVATE)
	  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	  e3:SetCode(EVENT_FREE_CHAIN)
	  e3:SetCountLimit(1,46232525)
	  e3:SetTarget(s.target)
	  e3:SetOperation(s.activate)
	  tc:RegisterEffect(e3,true)
	  tc:RegisterFlagEffect(id,0,0,0)
	end 
end
function s.tgfilter(c,e,tp)
	return c:IsMonster() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace(),c:GetType(),c)
end
function s.spfilter(c,e,tp,race,ctype,mc)
	return c:IsType(TYPE_FUSION) and c.material_race and c.material_type and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and race==c.material_race and ctype==c.material_type
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		local race=tc:GetRace()
		local ctype=tc:GetCode()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_GRAVE) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,race,ctype)
		local sc=sg:GetFirst()
		if sc then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end