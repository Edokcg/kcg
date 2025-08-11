--コクーン・リボーン
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
s.list={[42682609]=17955766,[43751755]=43237273,[17363041]=54959865,
				[29246354]=17732278,[16241441]=89621922,[42239546]=80344569}
s.listed_series={SET_CHRYSALIS,0x1f}

function s.filter1(c,e,tp)
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
	return chk and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tcode,e,tp)
end
function s.filter2(c,tcode,e,tp)
	return c:IsSetCard(0x1f) and not c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #rg<1 then return end
	for _,tcode in ipairs(rg:GetFirst().listed_names) do
		local typ=Duel.GetCardTypeFromCode(tcode)
		if typ&(TYPE_MONSTER)~=0 then
			rg:GetFirst():SetEntityCode(tcode, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
			aux.CopyCardTable(tcode,rg:GetFirst())
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tcode,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			break
		end
	end
end
