--コクーン・ヴェール
--Cocoon Veil
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_CHRYSALIS,0x1f}

function s.cfilter(c,e,tp)
	if c:IsFacedown() or not c:IsSetCard(SET_CHRYSALIS) or not c.listed_names then return false end
	local chk=false
	local tcode=0
	for _,v in ipairs(c.listed_names) do
		local typ=Duel.GetCardTypeFromCode(v)
		if typ&(TYPE_MONSTER)~=0 then
			chk=true
			tcode=v
			break
		end
	end
	return chk
end
function s.filter2(c,tcode,e,tp)
	return c:IsSetCard(0x1f) and not c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local rg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #rg<1 then return end
	for _,tcode in ipairs(rg:GetFirst().listed_names) do
		local typ=Duel.GetCardTypeFromCode(tcode)
		if typ&(TYPE_MONSTER)~=0 then
			rg:GetFirst():SetEntityCode(tcode, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tcode,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			break
		end
	end
end
function s.damval(e,re,val,r,rp,rc)
	if r&REASON_EFFECT~=0 then
		return 0
	else
		return val
	end
end
