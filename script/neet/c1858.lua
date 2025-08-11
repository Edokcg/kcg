--凶导之白天顶(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot be special summoned
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.ritlimit)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.target)
	c:RegisterEffect(e2)   
	--cannot trigger
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	--adjust
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.adjustcon)
	e4:SetOperation(s.adjustop)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=0
			s[1]=0
		end)
	end)
end
s.listed_names={31002402}
s.listed_series={SET_DOGMATIKA}
function s.ritlimit(e,se,sp,st)
	if (st&SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
		return se:GetHandler():IsSetCard(SET_DOGMATIKA)
	end
	return true
end
function s.target(e,c)
	return c:IsSummonLocation(LOCATION_DECK)
end
function s.cfilter(c,p)
	return c:IsSummonPlayer(p) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.cfilter,1,nil,0) then
		s[0]=s[0]+1
	end
	if eg:IsExists(s.cfilter,1,nil,1) then
		s[1]=s[1]+1
	end
end
function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,LOCATION_MZONE,0,1,nil,LOCATION_EXTRA) then return false end
	return s[1-tp]==5
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x104)
end