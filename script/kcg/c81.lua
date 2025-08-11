--接觸(KCG)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_CHRYSALIS}

function s.spfilter(c)
	if c:IsFacedown() or not c:IsSetCard(SET_CHRYSALIS) or not c.listed_names then return false end
	local chk=false
	for _,v in ipairs(c.listed_names) do
		local typ=Duel.GetCardTypeFromCode(v)
		if typ&(TYPE_MONSTER)~=0 then
			chk=true
			break
		end
	end
	return chk
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for c in aux.Next(g) do
        for _,v in ipairs(c.listed_names) do
            local typ=Duel.GetCardTypeFromCode(v)
            if typ&(TYPE_MONSTER)~=0 then
                c:SetEntityCode(v, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
                aux.CopyCardTable(v,c)
                break
            end
        end
    end
end
