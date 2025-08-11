--神·史莱姆·Ⅲ （neet）
local s,id=GetID()
function s.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_AQUA),s.matfilter)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--triple tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
 --cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(s.atklimit)
	c:RegisterEffect(e5)
end
s.listed_names={id}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WATER,fc,sumtype,tp) and c:GetLevel()==10
end
function s.hspfilter(c,tp,sc)
	return c:IsRace(RACE_AQUA) and c:GetLevel()==10 and c:GetAttack()==0 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,s.hspfilter,1,false,1,true,c,tp,nil,nil,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,s.hspfilter,1,1,false,true,true,c,tp,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	g:DeleteGroup()
end
function s.atklimit(e,c)
	return c==e:GetHandler()
end