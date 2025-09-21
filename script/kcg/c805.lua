--光之创造神 哈拉克提
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,3,id,1)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(3)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()
    
	--融合特召限制
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	
	--融合特召规则
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	e2:SetValue(805)
	c:RegisterEffect(e2)
end
s.listed_names = {10000000, CARD_RA, 10000020}
---------------------------------------------------------------------------------------------------------------
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
-----------------------------------------------------------------------------------------
function s.DGDfiler(c,e,tp)
	return c:IsCode(10000020) and c:IsFaceup() and c:IsRace(RACE_CREATORGOD)
	 and Duel.CheckReleaseGroup(tp,s.DGDfiler2,1,nil,c,e,tp)
end
function s.DGDfiler2(c,tc1,e,tp)
	local g=Group.FromCards(tc1,c)
	return c:IsCode(10000000) and c:IsFaceup() and c~=tc1 and c:IsRace(RACE_CREATORGOD)
	 and Duel.CheckReleaseGroup(tp,s.DGDfiler3,1,nil,g,e,tp)
end
function s.DGDfiler3(c,g,e,tp)
	local ag=g
	if ag:IsContains(c)	then return false end
	ag:AddCard(c)
	return c:IsCode(10000010) and c:IsFaceup() and c:IsRace(RACE_CREATORGOD)
	and Duel.GetLocationCountFromEx(tp,tp,ag,e:GetHandler())>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,s.DGDfiler,1,nil,e,tp)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.CheckReleaseGroup(tp,s.DGDfiler,1,nil,e,tp) then
	local gt1=Duel.SelectMatchingCard(tp,s.DGDfiler,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
    if not gt1 then return end
	local gt2=Duel.SelectMatchingCard(tp,s.DGDfiler2,tp,LOCATION_MZONE,0,1,1,nil,gt1,e,tp):GetFirst()
    if not gt2 then return end
	local gt3=Duel.SelectMatchingCard(tp,s.DGDfiler3,tp,LOCATION_MZONE,0,1,1,nil,Group.FromCards(gt1,gt2),e,tp):GetFirst()
    if not gt3 then return end
	local agt=Group.FromCards(gt1,gt2,gt3)
	Duel.Release(agt,REASON_COST+REASON_RULE+REASON_EFFECT)
	end
end